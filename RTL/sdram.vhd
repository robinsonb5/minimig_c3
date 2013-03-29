------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Copyright (c) 2009-2011 Tobias Gubener                                   -- 
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
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sdram is
generic
	(
		rows : integer := 12;
		cols : integer := 10
	);
port
	(
	sdata		: inout std_logic_vector(15 downto 0);
	sdaddr		: out std_logic_vector(rows-1 downto 0);
	dqm			: out std_logic_vector(1 downto 0);
	sd_cs		: out std_logic_vector(3 downto 0);
	ba			: buffer std_logic_vector(1 downto 0);
	sd_we		: out std_logic;
	sd_ras		: out std_logic;
	sd_cas		: out std_logic;

	sysclk		: in std_logic;
	reset_in	: in std_logic;
	
	hostWR		: in std_logic_vector(15 downto 0);
	hostAddr	: in std_logic_vector(24 downto 1);
	hostState	: in std_logic_vector(2 downto 0);
	hostL		: in std_logic;
	hostU		: in std_logic;
	cpuWR		: in std_logic_vector(15 downto 0);
	cpuAddr		: in std_logic_vector(24 downto 1);
	cpuU		: in std_logic;
	cpuL		: in std_logic;
	cpustate	: in std_logic_vector(5 downto 0);
	cpu_dma		: in std_logic;
	chipWR		: in std_logic_vector(15 downto 0);
	chipAddr	: in std_logic_vector(24 downto 1);
	chipU		: in std_logic;
	chipL		: in std_logic;
	chipRW		: in std_logic;
	chip_dma	: in std_logic;
	c_7m		: in std_logic;
	
	hostRD		: out std_logic_vector(15 downto 0);
	hostena		: buffer std_logic;
	cpuRD		: out std_logic_vector(15 downto 0);
	cpuena		: out std_logic;
	chipRD		: out std_logic_vector(15 downto 0);
	reset_out	: out std_logic;
	enaRDreg	: out std_logic;
	enaWRreg	: buffer std_logic;
	ena7RDreg	: out std_logic;
	ena7WRreg	: out std_logic
--	c_7m		: out std_logic
	);
end;

architecture rtl of sdram is


signal initstate	:std_logic_vector(3 downto 0);
signal cas_sd_cs	:std_logic_vector(3 downto 0);
signal cas_sd_ras	:std_logic;
signal cas_sd_cas	:std_logic;
signal cas_sd_we 	:std_logic;
signal cas_dqm		:std_logic_vector(7 downto 0);
signal init_done	:std_logic;
signal datain		:std_logic_vector(15 downto 0);
signal datawr		:std_logic_vector(15 downto 0);
signal casaddr		:std_logic_vector(24 downto 1);
signal sdwrite 		:std_logic;
signal sdata_reg	:std_logic_vector(15 downto 0);

signal hostCycle	:std_logic;
signal zmAddr		:std_logic_vector(24 downto 1);
signal zena			:std_logic;
signal zcache		:std_logic_vector(63 downto 0);
signal zcache_addr	:std_logic_vector(23 downto 1);
signal zcache_fill	:std_logic;
signal zcachehit	:std_logic;
signal zvalid		:std_logic_vector(3 downto 0);
signal zequal		:std_logic;
signal hostStated		:std_logic_vector(1 downto 0);
signal hostRDd	:std_logic_vector(15 downto 0);

signal cena			:std_logic;
signal ccache		:std_logic_vector(63 downto 0);
signal ccache_addr	:std_logic_vector(24 downto 1);
signal ccache_fill	:std_logic;
signal ccachehit	:std_logic;
signal cvalid		:std_logic_vector(3 downto 0);
signal cequal		:std_logic;
signal cpuStated	:std_logic_vector(1 downto 0);
signal cpuRDd		:std_logic_vector(15 downto 0);

signal dcache		:std_logic_vector(63 downto 0);
signal dcache_addr	:std_logic_vector(24 downto 1);
signal dcache_fill	:std_logic;
signal dcachehit	:std_logic;
signal dvalid		:std_logic_vector(3 downto 0);
signal dequal		:std_logic;

signal hostSlot_cnt	:std_logic_vector(7 downto 0);
signal reset_cnt	:std_logic_vector(7 downto 0);
signal reset		:std_logic;
signal reset_sdstate	:std_logic;

signal c_7md		:std_logic;
signal c_7mdd		:std_logic;
signal c_7mdr		:std_logic;
signal cpuCycle		:std_logic;
signal chipCycle	:std_logic;
signal slow			:std_logic_vector(7 downto 0);

signal refreshcnt : std_logic_vector(8 downto 0);
signal refresh_pending : std_logic;

type sdram_states is (ph0,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,ph10,ph11,ph12,ph13,ph14,ph15);
signal sdram_state		: sdram_states;
type pass_states is (nop,ras,cas);
signal pass		: pass_states;

signal cache_req : std_logic;
signal readcache_fill : std_logic;
signal cache_fill_1 : std_logic;
signal cache_fill_2 : std_logic;

type slot_type is (refresh,chip,cpu_readcache,cpu_writecache,host,idle);
signal slot1_type : slot_type := idle;
signal slot2_type : slot_type := idle;
signal slot1_bank : std_logic_vector(1 downto 0);
signal slot2_bank : std_logic_vector(1 downto 0);


COMPONENT TwoWayCache
	GENERIC ( WAITING : INTEGER := 0; WAITRD : INTEGER := 1; WAITFILL : INTEGER := 2; FILL2 : INTEGER := 3;
		 FILL3 : INTEGER := 4; FILL4 : INTEGER := 5; FILL5 : INTEGER := 6; PAUSE1 : INTEGER := 7 );
		
	PORT
	(
		clk		:	 IN STD_LOGIC;
		reset	: IN std_logic;
		ready : out std_logic;
		cpu_addr		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		cpu_req		:	 IN STD_LOGIC;
		cpu_ack		:	 OUT STD_LOGIC;
		cpu_wr_ack		:	 OUT STD_LOGIC;
		cpu_rw		:	 IN STD_LOGIC;
		cpu_rwl	: in std_logic;
		cpu_rwu : in std_logic;
		data_from_cpu		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_to_cpu		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdram_addr		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_from_sdram		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_to_sdram		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		sdram_req		:	 OUT STD_LOGIC;
		sdram_fill		:	 IN STD_LOGIC;
		sdram_rw		:	 OUT STD_LOGIC
	);
END COMPONENT;

-- Write buffer signals

--signal writebuffer_req : std_logic;
--signal writebuffer_ena : std_logic;
---- signal writebufferCycle : std_logic;
--signal writebuffer_dqm : std_logic_vector(1 downto 0);
--signal writebufferAddr : std_logic_vector(24 downto 1);
--signal writebufferWR : std_logic_vector(15 downto 0);
--signal writebuffer_cache_ack : std_logic;
--signal writebuffer_hold : std_logic; -- 1 during write access, cleared to indicate that the buffer can accept the next word.
--
--type writebuffer_states is (waiting,write1,write2,write3);
--signal writebuffer_state : writebuffer_states;

-- Write cache signals

type writecache_states is (waitwrite,fill,finish);
signal writecache_state : writecache_states;
signal writecache_state2 : writecache_states;

signal writecache_cycle : std_logic;
signal writecache_addr : std_logic_vector(31 downto 3);
signal writecache_word0 : std_logic_vector(15 downto 0);
signal writecache_word1 : std_logic_vector(15 downto 0);
signal writecache_word2 : std_logic_vector(15 downto 0);
signal writecache_word3 : std_logic_vector(15 downto 0);
signal writecache_dqm : std_logic_vector(7 downto 0);
signal writecache_req : std_logic;
signal writecache_ack : std_logic;
signal writecache_dirty : std_logic;
signal writecache_ena : std_logic;
signal writecache_release : std_logic;
signal writecache_burst : std_logic;


begin

	process (sysclk, reset_in) begin
		if reset_in = '0' THEN
			reset_cnt <= "00000000";
			reset <= '0';
			reset_sdstate <= '0';
		elsif (sysclk'event and sysclk='1') THEN
				IF reset_cnt="00101010"THEN
					reset_sdstate <= '1';
				END IF;
				IF reset_cnt="10101010"THEN
					if sdram_state=ph15 then 
						reset <= '1';
					end if;
				ELSE
					reset_cnt <= reset_cnt+1;
					reset <= '0';
				END IF;
		end if;
	end process;		
-------------------------------------------------------------------------
-- SPIHOST cache
-------------------------------------------------------------------------
	hostena <= '1' when zena='1' or hostState(1 downto 0)="01" OR zcachehit='1' else '0'; 

	-- Map host processor's address space to 0x400000
	zmAddr <= "00" & NOT hostAddr(22) & hostAddr(21 downto 1);
--	-- Map host processor's address space to 0xA00000
--	zmAddr <= '0'& NOT hostAddr(23) & hostAddr(22) & NOT hostAddr(21) & hostAddr(20 downto 1);
	
	process (sysclk, zmAddr, hostAddr, zcache_addr, zcache, zequal, zvalid, hostRDd) 
	begin
		if zmAddr(23 downto 3)=zcache_addr(23 downto 3) THEN
			zequal <='1';
		else	
			zequal <='0';
		end if;	
		zcachehit <= '0';
		if zequal='1' and zvalid(0)='1' and hostStated(1)='0' THEN
			case (hostAddr(2 downto 1)&zcache_addr(2 downto 1)) is
				when "0000"|"0101"|"1010"|"1111"=>
					zcachehit <= zvalid(0);
					hostRD <= zcache(63 downto 48);
				when "0100"|"1001"|"1110"|"0011"=>
					zcachehit <= zvalid(1);
					hostRD <= zcache(47 downto 32);
				when "1000"|"1101"|"0010"|"0111"=>
					zcachehit <= zvalid(2);
					hostRD <= zcache(31 downto 16);
				when "1100"|"0001"|"0110"|"1011"=>
					zcachehit <= zvalid(3);
					hostRD <= zcache(15 downto 0);
				when others=> null;
			end case;	
		else	
			hostRD <= hostRDd;
		end if;	
	end process;		
		
	
--Daten�bernahme
	process (sysclk, reset) begin
		if reset = '0' THEN
			zcache_fill <= '0';
			zena <= '0';
			zvalid <= "0000";
		elsif (sysclk'event and sysclk='1') THEN
				if enaWRreg='1' THEN
					zena <= '0';
				end if;
				if sdram_state=ph9 AND slot1_type=host THEN 
					hostRDd <= sdata_reg;
				end if;
				
				-- The cache will take care of enabling the host for instruction read cycles,
				-- but for write cycles and data read cycles we need to enable it separately.
				if sdram_state=ph11 AND slot1_type=host
					and (hostState(1 downto 0)="11" or hostState(1 downto 0)="10") THEN 
--					if zmAddr=casaddr and cas_sd_cas='0' then
						zena <= '1';
--					end if;
				end if;
				hostStated <= hostState(1 downto 0);
				if zequal='1' and hostState(1 downto 0)="11" THEN
					zvalid <= "0000";
				end if;
					case sdram_state is	
						when ph7 =>	
										if hostStated(1)='0' AND slot1_type=host THEN	--only instruction cache
											zcache_addr <= casaddr(23 downto 1);
											zcache_fill <= '1';
											zvalid <= "0000";
										end if;
						when ph9 =>	
										if zcache_fill='1' THEN
											zcache(63 downto 48) <= sdata_reg;
										end if;
						when ph10 =>	
										if zcache_fill='1' THEN
											zcache(47 downto 32) <= sdata_reg;
										end if;
						when ph11 =>	
										if zcache_fill='1' THEN
											zcache(31 downto 16) <= sdata_reg;
										end if;
						when ph12 =>	
										if zcache_fill='1' THEN
											zcache(15 downto 0) <= sdata_reg;
											zvalid <= "1111";
										end if;
										zcache_fill <= '0';
						when others =>	null;
					end case;	
			end if;
	end process;		
	
-------------------------------------------------------------------------
-- cpu cache
-------------------------------------------------------------------------

mytwc : component TwoWayCache
	PORT map
	(
		clk => sysclk,
		reset => reset,
		ready => open,
		cpu_addr => "0000000"&cpuAddr&'0',
		cpu_req => not cpustate(2),
		cpu_ack => ccachehit,
		cpu_wr_ack => writecache_ack,
		cpu_rw => NOT cpuState(1) OR NOT cpuState(0),
		cpu_rwl => cpuL,
		cpu_rwu => cpuU,
		data_from_cpu => cpuWR,
		data_to_cpu => cpuRD,
		sdram_addr(31 downto 3) => open,
		sdram_addr(2 downto 0) => open,
		data_from_sdram => sdata_reg,
		data_to_sdram => open,
		sdram_req => cache_req,
		sdram_fill => readcache_fill,
		sdram_rw => open
	);

	
-- Write Cache

process(sysclk)
begin
	if reset='0' then
		writecache_req<='0';
		writecache_ena<='0';
		writecache_dqm<="11111111";
		writecache_state<=waitwrite;
		writecache_state2<=waitwrite;
		writecache_release<='0';
	elsif rising_edge(sysclk) then

		-- Second state machine to monitor the read cache.
		case writecache_state2 is
			when waitwrite =>
				if cpuState(2 downto 0)="011" and writecache_ack='1' then
					writecache_release<='1'; -- Allow the processor to continue
					writecache_state2<=fill;
				end if;
			when fill =>
				if cpustate(2)='1' then
					writecache_release<='0';
					writecache_state2<=waitwrite;
				end if;
			when others =>
				null;
		end case;
	
		-- Main state machine
		writecache_ena<='0';
		case writecache_state is
			when waitwrite =>
				if cpuState(2 downto 0)="011" then -- write request
					if writecache_dirty='0' or cpuAddr(24 downto 3)=writecache_addr(24 downto 3) then
						writecache_addr(31 downto 25)<=(others =>'0');
						writecache_addr(24 downto 3)<=cpuAddr(24 downto 3);
						case cpuAddr(2 downto 1) is
							when "00" =>
								if cpuU='0' then
									writecache_word0(15 downto 8)<=cpuWR(15 downto 8);
									writecache_dqm(1)<='0';
								end if;
								if cpuL='0' then
									writecache_word0(7 downto 0)<=cpuWR(7 downto 0);
									writecache_dqm(0)<='0';
								end if;
--								writecache_dqm(1 downto 0)<=cpuU&cpuL;
							when "01" =>
								if cpuU='0' then
									writecache_word1(15 downto 8)<=cpuWR(15 downto 8);
									writecache_dqm(3)<='0';
								end if;
								if cpuL='0' then
									writecache_word1(7 downto 0)<=cpuWR(7 downto 0);
									writecache_dqm(2)<='0';
								end if;
--								writecache_dqm(3 downto 2)<=cpuU&cpuL;
							when "10" =>
								if cpuU='0' then
									writecache_word2(15 downto 8)<=cpuWR(15 downto 8);
									writecache_dqm(5)<='0';
								end if;
								if cpuL='0' then
									writecache_word2(7 downto 0)<=cpuWR(7 downto 0);
									writecache_dqm(4)<='0';
								end if;
--								writecache_dqm(5 downto 4)<=cpuU&cpuL;
							when "11" =>
								if cpuU='0' then
									writecache_word3(15 downto 8)<=cpuWR(15 downto 8);
									writecache_dqm(7)<='0';
								end if;
								if cpuL='0' then
									writecache_word3(7 downto 0)<=cpuWR(7 downto 0);
									writecache_dqm(6)<='0';
								end if;
--								writecache_dqm(7 downto 6)<=cpuU&cpuL;
						end case;
						writecache_req<='1';

						writecache_ena<=(not cpuState(2)) and writecache_release; -- Will be held until CPU unpauses.
						writecache_dirty<='1';
					end if;
				end if;
				if writecache_burst='1' and writecache_dirty='1' then
					writecache_req<='0';
					writecache_state<=fill;
				end if;
			when fill =>
				if writecache_burst='0' then
					writecache_dirty<='0';
					writecache_dqm<="11111111";
					writecache_state<=waitwrite;
				end if;
			when others =>
				null;
		end case;
				
	end if;
end process;


	cpuena <= '1' when ccachehit='1' or writecache_ena='1' else '0'; 
	readcache_fill<='1' when
		(cache_fill_1='1' and slot1_type=cpu_readcache) or
		(cache_fill_2='1' and slot2_type=cpu_readcache)
			else '0';

	
-------------------------------------------------------------------------
-- chip cache
-------------------------------------------------------------------------
	process (sysclk, sdata_reg)
    begin
		if (sysclk'event and sysclk='1') THEN
			if sdram_state=ph9 AND chipCycle='1' THEN 
				chipRD <= sdata_reg;
			end if;
		end if;
	end process;		
	
	
-------------------------------------------------------------------------
-- SDRAM Basic
-------------------------------------------------------------------------
	reset_out <= init_done;

	process (sysclk, reset, sdwrite, datain) begin
		IF sdwrite='1' THEN
			sdata <= datain;
--			sdata <= datawr;
		ELSE
			sdata <= "ZZZZZZZZZZZZZZZZ";
		END IF;
		if (sysclk'event and sysclk='0') THEN
			c_7md <= c_7m;
		END IF;

		if (sysclk'event and sysclk='1') THEN
--			if sdram_state=ph2 THEN
--				IF chipCycle='1' THEN
--					datawr <= chipWR;
--				ELSIF cpuCycle='1' THEN
--					datawr <= writebufferWR;
--				ELSE	
--					datawr <= hostWR;
--				END IF;
--			END IF;
			sdata_reg <= sdata;
			c_7mdd <= c_7md;
			c_7mdr <= c_7md AND NOT c_7mdd;
			if reset_sdstate = '0' then
				sdwrite <= '0';
				enaRDreg <= '0';
				enaWRreg <= '0';
				ena7RDreg <= '0';
				ena7WRreg <= '0';
			ELSE	
				sdwrite <= '0';
				enaRDreg <= '0';
				enaWRreg <= '0';
				ena7RDreg <= '0';
				ena7WRreg <= '0';
				case sdram_state is	--LATENCY=3
					when ph2 =>	enaWRreg <= '1';
					when ph3 =>	sdwrite <= '1';
					when ph4 =>	sdwrite <= '1';
					when ph5 => sdwrite <= '1';
					when ph6 =>	enaWRreg <= '1';
								ena7RDreg <= '1';
						if cas_sd_we='0' then
							sdwrite <= '1';
						end if;
					when ph7 =>	
						if cas_sd_we='0' then
							sdwrite <= '1';
						end if;
					when ph10 => enaWRreg <= '1';
					when ph11 => sdwrite<= '1';	-- Access slot 2
					when ph12 => sdwrite<= '1';
					when ph13 => sdwrite<= '1';
					when ph14 => enaWRreg <= '1';
								ena7WRreg <= '1';
						if cas_sd_we='0' then
							sdwrite <= '1';
						end if;
					when ph15 =>
						if cas_sd_we='0' then
							sdwrite <= '1';
						end if;
					when others => null;
				end case;	
			END IF;	
			if reset = '0' then
				initstate <= (others => '0');
				init_done <= '0';
			ELSE	
				case sdram_state is	--LATENCY=3
					when ph15 => if initstate /= "1111" THEN
									initstate <= initstate+1;
								else
									init_done <='1';	
								end if;
					when others => null;
				end case;	
			END IF;	
			IF c_7mdr='1' THEN
				sdram_state <= ph2;
			ELSE
				case sdram_state is	--LATENCY=3
					when ph0 =>	sdram_state <= ph1;
					when ph1 =>	sdram_state <= ph2;
					when ph2 =>	sdram_state <= ph3;
					when ph3 =>	sdram_state <= ph4;
					when ph4 =>	sdram_state <= ph5;
					when ph5 =>	sdram_state <= ph6;
					when ph6 =>	sdram_state <= ph7;
					when ph7 => sdram_state <= ph8;
					when ph8 =>	sdram_state <= ph9;
					when ph9 =>	sdram_state <= ph10;
					when ph10 => sdram_state <= ph11;
					when ph11 => sdram_state <= ph12;
					when ph12 => sdram_state <= ph13;
					when ph13 => sdram_state <= ph14;
					when ph14 => sdram_state <= ph15;
					when others => sdram_state <= ph0;
				end case;	
			END IF;	
		END IF;	
	end process;		


	
	process (sysclk, initstate, pass, hostAddr, datain, init_done, casaddr, cpuU, cpuL, hostCycle) begin



		if (sysclk'event and sysclk='1') THEN
			sd_cs <="1111";
			sd_ras <= '1';
			sd_cas <= '1';
			sd_we <= '1';
			sdaddr <= "XXXXXXXXXXXX";
			ba <= "00";
			dqm <= "00";
			
			cache_fill_1<='0';
			cache_fill_2<='0';

			if cpuState(5)='1' then
				cena<='0';
			end if;
			
			if init_done='0' then
				if sdram_state =ph1 then
					case initstate is
						when "0010" => --PRECHARGE
							sdaddr(10) <= '1'; 	--all banks
							sd_cs <="0000";
							sd_ras <= '0';
							sd_cas <= '1';
							sd_we <= '0';
						when "0011"|"0100"|"0101"|"0110"|"0111"|"1000"|"1001"|"1010"|"1011"|"1100" => --AUTOREFRESH
							sd_cs <="0000"; 
							sd_ras <= '0';
							sd_cas <= '0';
							sd_we <= '1';
						when "1101" => --LOAD MODE REGISTER
							sd_cs <="0000";
							sd_ras <= '0';
							sd_cas <= '0';
							sd_we <= '0';
--							sdaddr <= "001000110010"; --BURST=4 LATENCY=3
							sdaddr <= "000000110010"; --BURST=4 LATENCY=3
						when others =>	null;	--NOP
					end case;
				END IF;
			else		
	
-- Time slot control
-- Split the address space up like so:
-- rrbb rrrr rrrr rrcc cccc cccc
-- b: 24 downto 23
-- r: rows+cols downto cols+1
-- c: cols downto 1

				if sdram_state=ph0 then
					cache_fill_2<='1';
				end if;

				if sdram_state=ph1 THEN

					cache_fill_2<='1';

					cpuCycle <= '0';
					chipCycle <= '0';
					hostCycle <= '0';
					cas_sd_cs <= "1110"; 
					cas_sd_ras <= '1';
					cas_sd_cas <= '1';
					cas_sd_we <= '1';
					IF slow(2 downto 0)=5 THEN
						slow <= slow+3;
					ELSE
						slow <= slow+1;
					END IF;

					IF hostSlot_cnt /= "00000000" THEN
						hostSlot_cnt <= hostSlot_cnt-1;
					END IF;
					if refreshcnt = "000000000" then
						refresh_pending<='1';
					else
						refreshcnt <= refreshcnt-1;
					end if;

					slot1_bank<="00"; -- All chipset and OSD accesses are to bank 0
-- 				We give the chipset first priority...
					IF chip_dma='0' OR chipRW='0' THEN
						slot1_type<=chip; -- chipCycle <= '1';
						chipCycle <= '1';
						sdaddr <= chipAddr((rows+cols) downto (cols+1));
						ba <= chipAddr((rows+cols+2) downto (rows+cols+1));
						cas_dqm <= "111111"&chipU& chipL;
						sd_cs <= "1110"; 	--ACTIVE
						sd_ras <= '0';
						casaddr <= chipAddr;	
						datain <= chipWR;
						cas_sd_cas <= '0';
						cas_sd_we <= chipRW;

-- 				Next in line is refresh...
					elsif refresh_pending='1' and slot2_type=idle then
						slot1_type<=refresh; -- chipCycle <= '1';
						sd_cs <="0000"; --AUTOREFRESH
						sd_ras <= '0';
						sd_cas <= '0';
						refreshcnt <= "111111111";
						refresh_pending<='0';
						
--					The Amiga CPU gets next bite of the cherry, unless the OSD CPU has been cycle-starved...
					ELSIF writecache_req='1' and (slot2_type=idle or slot2_bank/=writecache_addr((rows+cols+2) downto (rows+cols+1)))
						and (hostslot_cnt/="00000000" or (hostState(2)='1' or hostena='1'))
--						and (slot2_type=idle or slot2_bank/=writebufferAddr(24 downto 23))
							then
							-- We only yeild to the OSD CPU if it's both cycle-starved and ready to go.
						slot1_type<=cpu_writecache;
						cpuCycle <= '1';
						sdaddr <= writecache_addr((rows+cols) downto (cols+1));
						ba <= writecache_addr((rows+cols+2) downto (rows+cols+1));
						slot1_bank<=writecache_addr((rows+cols+2) downto (rows+cols+1));
						cas_dqm <= writecache_dqm;
						sd_cs <= "1110"; --ACTIVE
						sd_ras <= '0';
						casaddr <= writecache_addr(24 downto 3)&"00";
						cas_sd_we <= '0';
--						datain <= writebufferWR;
						cas_sd_cas <= '0';
					ELSIF cache_req='1' and (slot2_type=idle or slot2_bank/=cpuAddr((rows+cols+2) downto (rows+cols+1)))
						and (hostslot_cnt/="00000000" or (hostState(2)='1' or hostena='1')) THEN	
						-- We only yeild to the OSD CPU if it's both cycle-starved and ready to go.
						slot1_type<=cpu_readcache; -- chipCycle <= '1';
						cpuCycle <= '1';
						sdaddr <= cpuAddr((rows+cols) downto (cols+1));
						ba <= cpuAddr((rows+cols+2) downto (rows+cols+1));
						slot1_bank<=cpuAddr((rows+cols+2) downto (rows+cols+1));
--						cas_dqm <= "111111"&cpuU& cpuL;
						sd_cs <= "1110"; --ACTIVE
						sd_ras <= '0';
						casaddr <= cpuAddr(24 downto 1);
--						datain <= cpuWR;
						cas_sd_cas <= '0';
--						cas_sd_we <= '1';
					ELSIF hostState(2)='0' AND hostena='0' THEN
						slot1_type<=host; -- chipCycle <= '1';
						hostSlot_cnt <= "00001111";
						hostCycle <= '1';
						sdaddr <= zmAddr((rows+cols) downto (cols+1));
						ba <= "00"; -- zmAddr((rows+cols+2) downto (rows+cols+1));
						cas_dqm <= "111111"&hostU& hostL;
						sd_cs <= "1110"; --ACTIVE
						sd_ras <= '0';
						casaddr <= zmAddr;
						datain <= hostWR;
						cas_sd_cas <= '0';
						IF hostState="011" THEN
							cas_sd_we <= '0';
						END IF;
					else
						slot1_type<=idle;
--						If no-one else wants this cycle we refresh the RAM.
--						slot1_type<=refresh; -- chipCycle <= '1';
--						sd_cs <="0000"; --AUTOREFRESH
--						sd_ras <= '0';
--						sd_cas <= '0';
--						refreshcnt <= "111111111";
					END IF;
				END IF;

				if sdram_state=ph2 then
					cache_fill_2<='1';
					if slot1_type=cpu_writecache then
						writecache_burst<='1'; -- Close the door on this burst write.
					end if;
				end if;

				if sdram_state=ph3 then
					cache_fill_2<='1';
				end if;

				if sdram_state=ph4 then
					sdaddr(rows-1 downto 11)<=(others=>'0');
					sdaddr(10) <='1';
					sdaddr(9 downto 0) <= casaddr(10 downto 1);--auto precharge
					ba <= casaddr((rows+cols+2) downto (rows+cols+1));
					sd_cs <= cas_sd_cs; 
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(1 downto 0);
					END IF;
					sd_ras <= cas_sd_ras;
					sd_cas <= cas_sd_cas;
					sd_we  <= cas_sd_we;
					if slot1_type=cpu_writecache then
						datain <= writecache_word0;
					end if;
				END IF;

				if sdram_state=ph5 then
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(3 downto 2);
						datain <= writecache_word1;
					END IF;
				end if;

				if sdram_state=ph6 then
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(5 downto 4);
						datain <= writecache_word2;
					END IF;
				end if;

				if sdram_state=ph7 then
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(7 downto 6);
						datain <= writecache_word3;
					END IF;
					writecache_burst<='0'; -- Close the door on this burst write.
				end if;
				
				if sdram_state=ph8 then
					cache_fill_1<='1';
				end if;
				
				if sdram_state=ph9 then
					cache_fill_1<='1';

--						Access slot 2, RAS
						cpuCycle <= '0';
						chipCycle <= '0';
						hostCycle <= '0';
						cas_sd_cs <= "1110"; 
						cas_sd_ras <= '1';
						cas_sd_cas <= '1';
						cas_sd_we <= '1';

						slot2_type<=idle;
						if refresh_pending='0' and slot1_type/=refresh then
							IF writecache_req='1'  and writecache_addr((rows+cols+2) downto (rows+cols+1))/="00" -- Reserve bank 0 for slot 1
								and (slot1_type=idle or slot1_bank/=writecache_addr((rows+cols+2) downto (rows+cols+1)))
									then
								-- We only yeild to the OSD CPU if it's both cycle-starved and ready to go.
								slot2_type<=cpu_writecache;
								cpuCycle <= '1';
								sdaddr <= writecache_addr((rows+cols) downto (cols+1));
								ba <= writecache_addr((rows+cols+2) downto (rows+cols+1));
								slot2_bank<=writecache_addr(24 downto 23);
								cas_dqm <= writecache_dqm;
								sd_cs <= "1110"; --ACTIVE
								sd_ras <= '0';
								casaddr <= writecache_addr(24 downto 3)&"00";
								cas_sd_we <= '0';
								cas_sd_cas <= '0';
								writecache_burst<='1';	-- Let the write buffer know we're about to write.

							-- Request from read cache
							ELSIF cache_req='1' and cpuAddr((rows+cols+2) downto (rows+cols+1))/="00" -- Reserve bank 0 for slot 1
								and (slot1_type=idle or slot1_bank/=cpuAddr((rows+cols+2) downto (rows+cols+1)))
								then
								slot2_type<=cpu_readcache; -- chipCycle <= '1';
								cpuCycle <= '1';
								sdaddr <= cpuAddr((rows+cols) downto (cols+1));
								ba <= cpuAddr((rows+cols+2) downto (rows+cols+1));
								slot2_bank<=cpuAddr((rows+cols+2) downto (rows+cols+1));
--								cas_dqm <= cpuU& cpuL;
								sd_cs <= "1110"; --ACTIVE
								sd_ras <= '0';
								casaddr <= cpuAddr(24 downto 1);
--								datain <= cpuWR;
								cas_sd_cas <= '0';
								cas_sd_we <= '1';
							end if;
						end if;

				end if;
				
				if sdram_state=ph10 then
					cache_fill_1<='1';
					if slot2_type<=cpu_writecache then
						writecache_burst<='1';  -- Close the door on this burst write.
					end if;
				end if;
				
				if sdram_state=ph11 then
					cache_fill_1<='1';
				end if;

				if sdram_state=ph12 then
					sdaddr(rows-1 downto 11)<=(others=>'0');
					sdaddr(10) <='1';
					sdaddr(9 downto 0) <= casaddr(10 downto 1);--auto precharge
					ba <= casaddr((rows+cols+2) downto (rows+cols+1));
					sd_cs <= cas_sd_cs; 
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(1 downto 0);
					END IF;
					sd_ras <= cas_sd_ras;
					sd_cas <= cas_sd_cas;
					sd_we  <= cas_sd_we;
					if slot2_type=cpu_writecache then
						datain <= writecache_word0;
					end if;
				END IF;

				if sdram_state=ph13 then
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(3 downto 2);
						datain <= writecache_word1;
					END IF;
				end if;

				if sdram_state=ph14 then
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(5 downto 4);
						datain <= writecache_word2;
					END IF;
				end if;

				if sdram_state=ph15 then
					IF cas_sd_we='0' THEN
						dqm <= cas_dqm(7 downto 6);
						datain <= writecache_word3;
					END IF;
					writecache_burst<='0'; -- Close the door on this burst write.
				end if;

			END IF;	
		END IF;	
	END process;
END;

--                Slot 1                       Slot 2
-- ph0 	(read)								(Read 0 in sdata)

-- ph1	Slot alloc, RAS (read)			Read0		

-- ph2	... (read)							Read1

-- ph3	... (write)							Read2 (read3 in sdata)

-- ph4	CAS, write0 (write) 				Read3

-- ph5	write1 (write)

-- ph6	write2 (write)

-- ph7	write3 (read)

-- ph8   (read0 in sdata) (rd)		

-- ph9	read0 in sdata_reg (rd)			Slot alloc, RAS

-- ph10	read1	(read)						...

-- ph11	read2 (rd3 in sdata, wr)		...

-- ph12	read3 (write)						CAS, write 0

-- ph13	(write)								write1

-- ph14	(write)								write2

-- ph15	(read)								write3
