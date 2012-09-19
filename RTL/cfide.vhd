------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Copyright (c) 2008-2011 Tobias Gubener                                   -- 
-- Subdesign fAMpIGA by TobiFlex                                            --
--                                                                          --
-- This source file is free software: you can redistribute it and/or modify --
-- it under the terms of the GNU General Public License as published        --
-- by the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                      --
--                                                                          --
-- This source file is distributed in the hope that it will be useful,      --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU General Public License for more details.                             --
--                                                                          --
-- You should have received a copy of the GNU General Public License        --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
--                                                                          --
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Modifications by Alastair M. Robinson to work with a cheap 
-- Ebay Cyclone III board.
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

 
entity cfide is
   port ( 
		sysclk: in std_logic;	
		n_reset: in std_logic;	
		cpuena_in: in std_logic;			
		memdata_in: in std_logic_vector(15 downto 0);		
		addr: in std_logic_vector(23 downto 0);
		cpudata_in: in std_logic_vector(15 downto 0);	
		state: in std_logic_vector(1 downto 0);		
		lds: in std_logic;			
		uds: in std_logic;
		sd_di		: in std_logic;
			
		memce: out std_logic;			
		cpudata: out std_logic_vector(15 downto 0);		
		cpuena: buffer std_logic;			
		sd_cs 		: out std_logic_vector(7 downto 0);
		sd_clk 		: out std_logic;
		sd_do		: out std_logic;
		sd_dimm		: in std_logic;		--for sdcard
		enaWRreg    : in std_logic:='1';
		debugTxD : out std_logic;
		debugRxD : in std_logic
   );

end cfide;


architecture rtl of cfide is


signal shift: std_logic_vector(9 downto 0);
signal clkgen: std_logic_vector(9 downto 0);
signal shiftout: std_logic;
signal txbusy: std_logic;
signal ld: std_logic;
signal KEY_select: std_logic;
signal PART_select: std_logic;
signal SPI_select: std_logic;
signal ROM_select: std_logic;
signal RAM_write: std_logic;
signal part_in: std_logic_vector(15 downto 0);
signal IOdata: std_logic_vector(15 downto 0);
signal IOcpuena: std_logic;


type support_states is (idle, io_aktion);
signal support_state		: support_states;
signal next_support_state		: support_states;

signal sd_out	: std_logic_vector(15 downto 0);
signal sd_in	: std_logic_vector(15 downto 0);
signal sd_in_shift	: std_logic_vector(15 downto 0);
signal sd_di_in	: std_logic;
signal shiftcnt	: std_logic_vector(13 downto 0);
signal sck		: std_logic;
signal scs		: std_logic_vector(7 downto 0);
signal dscs		: std_logic;
signal SD_busy		: std_logic;
signal spi_div: std_logic_vector(7 downto 0);
signal spi_speed: std_logic_vector(7 downto 0);
signal rom_data: std_logic_vector(15 downto 0);

signal timecnt: std_logic_vector(15 downto 0);
signal timeprecnt: std_logic_vector(15 downto 0);

signal enacnt: std_logic_vector(6 downto 0);

signal rs232_select : std_logic;
signal rs232data : std_logic_vector(15 downto 0);

begin

srom: entity work.OSDBootstrap
	PORT MAP 
	(
		address => addr(11 downto 1),	--: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		byteena(0)	=> not lds,			--	: IN STD_LOGIC_VECTOR (1 DOWNTO 0),
		byteena(1)	=> not uds,			--	: IN STD_LOGIC_VECTOR (1 DOWNTO 0),
		clock   => sysclk,								--: IN STD_LOGIC ;
		data	=> cpudata_in,		--	: IN STD_LOGIC_VECTOR (15 DOWNTO 0),
		wren	=> RAM_write AND enaWRreg,		-- 	: IN STD_LOGIC ,
		q		=> rom_data									--: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );


memce <= '0' WHEN ROM_select='0' AND addr(23)='0' ELSE '1';
cpudata <=  rom_data WHEN ROM_select='1' ELSE 
			IOdata WHEN IOcpuena='1' ELSE
			part_in WHEN PART_select='1' ELSE 
			memdata_in;
part_in <= 
			timecnt WHEN addr(4 downto 1)="1000" ELSE	--DEE010
			"XXXXXXXX"&"1"&"0000001";-- WHEN addr(4 downto 1)="1001" ELSE	--DEE012
			
IOdata <= sd_in;			

cpuena <= '1' WHEN ROM_select='1' OR PART_select='1' OR state="01" ELSE
		  IOcpuena WHEN rs232_select='1' OR SPI_select='1' ELSE 
		  cpuena_in; 

rs232data <= X"FFFF" WHEN txbusy='1' ELSE X"0000";

sd_in(15 downto 8) <= sd_in_shift(15 downto 8) WHEN lds='0' ELSE sd_in_shift(7 downto 0); 
sd_in(7 downto 0) <= sd_in_shift(7 downto 0);

RAM_write <= '1' when ROM_select='1' AND state="11" ELSE '0';
ROM_select <= '1' when addr(23 downto 12)=X"000" ELSE '0';
rs232_select <= '1' when addr(23 downto 12)=X"DA8" ELSE '0';
KEY_select <= '1' when addr(23 downto 12)=X"DE0" ELSE '0';
PART_select <= '1' when addr(23 downto 12)=X"DEE" ELSE '0';
SPI_select <= '1' when addr(23 downto 12)=X"DA4" AND state(1)='1' ELSE '0';

-----------------------------------------------------------------
-- Support States
-----------------------------------------------------------------
process(sysclk, shift)
begin
  	IF sysclk'event AND sysclk = '1' THEN
		IF enaWRreg='1' THEN
			support_state <= idle;
			ld <= '0';
			IOcpuena <= '0';
			CASE support_state IS
				WHEN idle => 
					IF rs232_select='1' AND state="11" THEN
						IF txbusy='0' THEN
							ld <= '1';
							support_state <= io_aktion;
							IOcpuena <= '1';
						END IF;	
					ELSIF SPI_select='1' THEN		
						IF SD_busy='0' THEN
							support_state <= io_aktion;
							IOcpuena <= '1';
						END IF;
					END IF;
						
				WHEN io_aktion => 
					support_state <= idle;
					
				WHEN OTHERS => 
					support_state <= idle;
			END CASE;
		END IF;	
	END IF;	
end process; 

-----------------------------------------------------------------
-- SPI-Interface
-----------------------------------------------------------------	
	sd_cs <= NOT scs;
	sd_clk <= NOT sck;
	sd_do <= sd_out(15);
	SD_busy <= shiftcnt(13);
	
	PROCESS (sysclk, n_reset, scs, sd_di, sd_dimm) BEGIN
		IF scs(1)='0' THEN
			sd_di_in <= sd_di;
		ELSE	
			sd_di_in <= sd_dimm;
		END IF;
		IF n_reset ='0' THEN 
			shiftcnt <= (OTHERS => '0');
			spi_div <= (OTHERS => '0');
			scs <= (OTHERS => '0');
			sck <= '0';
			spi_speed <= "00000000";
			dscs <= '0';
		ELSIF (sysclk'event AND sysclk='1') THEN
		IF enaWRreg='1' THEN
			IF SPI_select='1' AND state="11" AND SD_busy='0' THEN	 --SD write
				IF addr(3)='1' THEN				--DA4008
					spi_speed <= cpudata_in(7 downto 0);
				ELSIF addr(2)='1' THEN				--DA4004
					scs(0) <= not cpudata_in(0);
					IF cpudata_in(7)='1' THEN
						scs(7) <= not cpudata_in(0);
					END IF;
					IF cpudata_in(6)='1' THEN
						scs(6) <= not cpudata_in(0);
					END IF;
					IF cpudata_in(5)='1' THEN
						scs(5) <= not cpudata_in(0);
					END IF;
					IF cpudata_in(4)='1' THEN
						scs(4) <= not cpudata_in(0);
					END IF;
					IF cpudata_in(3)='1' THEN
						scs(3) <= not cpudata_in(0);
					END IF;
					IF cpudata_in(2)='1' THEN
						scs(2) <= not cpudata_in(0);
					END IF;
					IF cpudata_in(1)='1' THEN
						scs(1) <= not cpudata_in(0);
					END IF;
				ELSE							--DA4000
					spi_div <= spi_speed;
					sd_out <= cpudata_in(15 downto 0);
					IF scs(6)='1' THEN		-- SPI direkt Mode
						shiftcnt <= "10111111111111";
						sd_out <= "1111111111111111";
					ELSIF uds='0' AND lds='0' THEN
						shiftcnt <= "10000000001111";
					ELSE
						shiftcnt <= "10000000000111";
						IF lds='0' THEN
							sd_out(15 downto 8) <= cpudata_in(7 downto 0);
						END IF;
					END IF;
					sck <= '1';
				END IF;
			ELSE
				IF spi_div="00000000" THEN
					spi_div <= spi_speed;
					IF SD_busy='1' THEN
						IF sck='0' THEN
							IF shiftcnt(12 downto 0)/="0000000000000" THEN
								sck <='1';
							END IF;
							shiftcnt <= shiftcnt-1;
							sd_out <= sd_out(14 downto 0)&'1';
						ELSE	
							sck <='0';
							sd_in_shift <= sd_in_shift(14 downto 0)&sd_di_in;
						END IF;
					END IF;
				ELSE
					spi_div <= spi_div-1;
				END IF;
			END IF;		
		END IF;		
		END IF;		
	END PROCESS;

-----------------------------------------------------------------
-- Simple UART only TxD
-----------------------------------------------------------------
debugTxD <= not shiftout;
process(n_reset, sysclk, shift)
begin
	if shift="0000000000" then
		txbusy <= '0';
	else
		txbusy <= '1';
	end if;

	if n_reset='0' then
		shiftout <= '0';
		shift <= "0000000000"; 
	elsif sysclk'event and sysclk = '1' then
	IF enaWRreg='1' THEN
		if ld = '1' then
			IF lds='0'THEN
				shift <=  '1' & cpudata_in(7 downto 0) & '0';			--STOP,MSB...LSB, START
			ELSE	
				shift <=  '1' & cpudata_in(15 downto 8) & '0';			--STOP,MSB...LSB, START
			END IF;		
		end if;
		if clkgen/=0 then
			clkgen <= clkgen-1;
		else	
--			clkgen <= "1110101001";--937;		--108MHz/115200
--			clkgen <= "0011101010";--234;		--27MHz/115200
			clkgen <= "0011111000";--249-1;		--28,7MHz/115200
--			clkgen <= "0011110101";--246-1;		--28,7MHz/115200
--			clkgen <= "0001111100";--249-1;		--14,3MHz/115200
			shiftout <= not shift(0) and txbusy;
		   	shift <=  '0' & shift(9 downto 1);
		end if;
	END IF;		
	end if;
end process; 


-----------------------------------------------------------------
-- timer
-----------------------------------------------------------------
process(sysclk)
begin
   	IF sysclk'event AND sysclk = '1' THEN
	IF enaWRreg='1' THEN
		IF timeprecnt=0 THEN
			timeprecnt <= X"3808";
			timecnt <= timecnt+1;
		ELSE
			timeprecnt <= timeprecnt-1;
		END IF;
	END IF;
	end if;
end process; 

end;  

