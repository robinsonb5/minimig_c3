------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Copyright (c) 2009-2011 Tobias Gubener                                   -- 
-- Subdesign fAMpIGA by TobiFlex                                            --
--                                                                          --
-- This is the TOP-Level for TG68KdotC_Kernel to generate 68K Bus signals   --
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

entity TG68K is
   port(        
		clk           : in std_logic;
		clk28 : in std_logic;
		reset         : in std_logic;
        IPL           : in std_logic_vector(2 downto 0):="111";
        dtack         : in std_logic;
        vpa           : in std_logic:='1';
        ein           : in std_logic:='1';
        addr          : buffer std_logic_vector(31 downto 0);
        data_read  	  : in std_logic_vector(15 downto 0);
        data_write 	  : out std_logic_vector(15 downto 0);
        as            : out std_logic;
        uds           : out std_logic;
        lds           : out std_logic;
        rw            : out std_logic;
        e             : out std_logic;
        vma           : buffer std_logic:='1';
        wrd           : out std_logic;
        ena7RDreg      : in std_logic:='1';
        ena7WRreg      : in std_logic:='1';
        enaWRreg      : in std_logic:='1';
        
        fromram    	  : in std_logic_vector(15 downto 0);
        toram    	  	: out std_logic_vector(15 downto 0);
        ramready      : in std_logic:='0';
		  cache_valid : in std_logic;
		  cacheable : out std_logic;
        cpu           : in std_logic_vector(1 downto 0);
		  fastramcfg	: in std_logic_vector(2 downto 0);
		  turbochipram : in std_logic;
        ramaddr    	  : out std_logic_vector(31 downto 0);
        cpustate      : out std_logic_vector(5 downto 0);
		nResetOut	  : out std_logic;
        skipFetch     : buffer std_logic;
        ramlds        : out std_logic;
        ramuds        : out std_logic
        );
end TG68K;

ARCHITECTURE logic OF TG68K IS


COMPONENT TG68KdotC_Kernel 
	generic(
		SR_Read : integer:= 2;         --0=>user,   1=>privileged,      2=>switchable with CPU(0)
		VBR_Stackframe : integer:= 2;  --0=>no,     1=>yes/extended,    2=>switchable with CPU(0)
		extAddr_Mode : integer:= 2;    --0=>no,     1=>yes,    2=>switchable with CPU(1)
		MUL_Mode : integer := 2;	   --0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no MUL,  
		DIV_Mode : integer := 2;	   --0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no DIV,  
		BitField : integer := 2		   --0=>no,     1=>yes,    2=>switchable with CPU(1)  
		);
   port(clk               	: in std_logic;
        nReset             	: in std_logic;			--low active
        clkena_in         	: in std_logic:='1';
        data_in          	: in std_logic_vector(15 downto 0);
		IPL				  	: in std_logic_vector(2 downto 0):="111";
		IPL_autovector   	: in std_logic:='0';
		CPU             	: in std_logic_vector(1 downto 0):="00";  -- 00->68000  01->68010  11->68020(only same parts - yet)
        addr           		: buffer std_logic_vector(31 downto 0);
        data_write        	: out std_logic_vector(15 downto 0);
		nWr			  		: out std_logic;
		nUDS, nLDS	  		: out std_logic;
		nResetOut	  		: out std_logic;
        FC              	: out std_logic_vector(2 downto 0);
-- for debug		
		busstate	  	  	: out std_logic_vector(1 downto 0);	-- 00-> fetch code 10->read data 11->write data 01->no memaccess
		skipFetch	  		: out std_logic;
        regin          		: buffer std_logic_vector(31 downto 0)
        );
	END COMPONENT;


   SIGNAL cpuaddr     : std_logic_vector(31 downto 0);
   SIGNAL t_addr      : std_logic_vector(31 downto 0);
--   SIGNAL data_write  : std_logic_vector(15 downto 0);
--   SIGNAL t_data      : std_logic_vector(15 downto 0);
   SIGNAL r_data      : std_logic_vector(15 downto 0);
   SIGNAL w_data      : std_logic_vector(15 downto 0);
   SIGNAL cpuIPL      : std_logic_vector(2 downto 0);
   SIGNAL as_s        : std_logic;
   SIGNAL as_e        : std_logic;
   SIGNAL uds_s       : std_logic;
   SIGNAL uds_e       : std_logic;
   SIGNAL lds_s       : std_logic;
   SIGNAL lds_e       : std_logic;
   SIGNAL rw_s        : std_logic;
   SIGNAL rw_e        : std_logic;
   SIGNAL vpad        : std_logic;
   SIGNAL waitm       : std_logic;
   SIGNAL clkena_e    : std_logic;
   SIGNAL S_state     : std_logic_vector(1 downto 0);
   SIGNAL S_stated     : std_logic_vector(1 downto 0);
   SIGNAL decode	  : std_logic;
   SIGNAL wr	      : std_logic;
   SIGNAL uds_in	  : std_logic;
   SIGNAL lds_in	  : std_logic;
   SIGNAL state       : std_logic_vector(1 downto 0);
   SIGNAL clkena	  : std_logic;
--   SIGNAL n_clk		  : std_logic;
   SIGNAL vmaena	  : std_logic;
   SIGNAL vmaenad	  : std_logic;
   SIGNAL sync_state3 : std_logic;
   SIGNAL eind	      : std_logic;
   SIGNAL eindd	      : std_logic;
	signal sel_interrupt : std_logic;
	signal sel_32bit : std_logic;
	signal sel_bridge : std_logic;
	signal sel_chipram : std_logic;
	signal sel_autoconfig : std_logic;
	signal sel_zorroii : std_logic;
	signal sel_zorroiii : std_logic;
	signal sel_fastram : std_logic;
	signal sel_turbochip : std_logic;
	signal cpu_rw : std_logic;
	SIGNAL turbochip_ena : std_logic := '0';
	SIGNAL turbochip_d : std_logic := '0';
   SIGNAL slower       : std_logic_vector(3 downto 0);

	signal ziiI_base : std_logic_vector(7 downto 0);
	signal ziiiram_ena : std_logic;
--	signal sel_ziiiram : std_logic;

	type sync_states is (sync0, sync1, sync2, sync3, sync4, sync5, sync6, sync7, sync8, sync9);
	signal sync_state		: sync_states;
	
   SIGNAL datatg68      : std_logic_vector(15 downto 0);
   SIGNAL ramcs	      : std_logic;

	
	signal ac_data1 : std_logic_vector(3 downto 0);
	signal ac_data2 : std_logic_vector(3 downto 0);
	signal autoconfig_data : std_logic_vector(3 downto 0);
	signal ac_req : std_logic;
	signal ac2_req : std_logic;
	signal ac3_req : std_logic;

	signal sdram_req113 : std_logic;
	signal sdram_req28 : std_logic;
	signal sdram_req : std_logic;
	signal fast_clkena : std_logic;
	signal cache_clkena : std_logic;


BEGIN  
	wrd <= wr;
	addr <= cpuaddr;

	cache_clkena <= '1' when cpu_rw='1' and cache_valid='1' and state/="01" else '0';
	clkena<='1' when clkena_e='1' or fast_clkena='1' or cache_clkena='1' else '0';

	datatg68 <= fromram when sel_fastram='1'
		else autoconfig_data&X"FFF" when sel_autoconfig='1'
		else r_data;

	cpustate <= clkena&slower(1 downto 0)&ramcs&state;

	ramaddr(20 downto 0) <= cpuaddr(20 downto 0);
	ramaddr(31 downto 25) <= "0000000";
	ramaddr(24) <= cpuaddr(30);	-- Remap the Zorro III RAM to 0x1000000
	ramaddr(23 downto 21) <= "100" when cpuaddr(30)&cpuaddr(23 downto 21)="0001" -- 2 -> 8
		else "101" when cpuaddr(30)&cpuaddr(23 downto 21)="0010" -- 4 -> A
		else "110" when cpuaddr(30)&cpuaddr(23 downto 21)="0011" -- 6 -> C
		else "111" when cpuaddr(30)&cpuaddr(23 downto 21)="0100" -- 8 -> E
		else cpuaddr(23 downto 21);	-- pass through others


pf68K_Kernel_inst: TG68KdotC_Kernel 
	generic map(
		SR_Read => 2,         	--0=>user,   1=>privileged,      2=>switchable with CPU(0)
		VBR_Stackframe => 2,  	--0=>no,     1=>yes/extended,    2=>switchable with CPU(0)
		extAddr_Mode => 2,    	--0=>no,     1=>yes,    2=>switchable with CPU(1)
		MUL_Mode => 2,	   		--0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no MUL,  
		DIV_Mode => 2		  	 --0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no DIV,  
		)
  PORT MAP(
        clk => clk28,               	-- : in std_logic;
        nReset => reset,            -- : in std_logic:='1';			--low active
        clkena_in => clkena,	        -- : in std_logic:='1';
        data_in => datatg68,       -- : in std_logic_vector(15 downto 0);
		IPL => cpuIPL,				  	-- : in std_logic_vector(2 downto 0):="111";
		IPL_autovector => '1',   	-- : in std_logic:='0';
        addr => cpuaddr,           	-- : buffer std_logic_vector(31 downto 0);
        data_write => w_data,     -- : out std_logic_vector(15 downto 0);
		busstate => state,	  	  	-- : buffer std_logic_vector(1 downto 0);	
        regin => open,          	-- : out std_logic_vector(31 downto 0);
		nWr => wr,			  	-- : out std_logic;
		nUDS => uds_in,
		nLDS => lds_in,	  			-- : out std_logic;
		nResetOut => nResetOut,
		CPU => cpu,
		skipFetch => skipFetch 		-- : out std_logic
        );
 		
				
PROCESS (clk, reset, state, as_s, as_e, rw_s, rw_e, uds_s, uds_e, lds_s, lds_e)
	BEGIN
		IF state="01" THEN 
			as <= '1';
			rw <= '1';
			uds <= '1';
			lds <= '1';
		ELSE
			as <= (as_s AND as_e) OR not sel_bridge;
			rw <= rw_s AND rw_e;
			uds <= uds_s AND uds_e;
			lds <= lds_s AND lds_e;
		END IF;

		IF reset='0' THEN
			S_state <= "00";
			as_s <= '1';
			rw_s <= '1';
			uds_s <= '1';
			lds_s <= '1';
		ELSIF rising_edge(clk28) THEN
        	IF ena7WRreg='1' THEN
				as_s <= '1';
				rw_s <= '1';
				uds_s <= '1';
				lds_s <= '1';
					CASE S_state IS
						WHEN "00" =>
							IF state/="01" AND sel_bridge='1' THEN
								uds_s <= uds_in;
								lds_s <= lds_in;
								S_state <= "01";
							 END IF;
						WHEN "01" =>
							as_s <= '0';
							data_write <= w_data;
							rw_s <= wr;
							uds_s <= uds_in;
							lds_s <= lds_in;
							S_state <= "10";
							t_addr <= cpuaddr;
						WHEN "10" =>
							r_data <= data_read;
							IF waitm='0' THEN
								S_state <= "11";
							ELSE	
								as_s <= '0';
								rw_s <= wr;
								uds_s <= uds_in;
								lds_s <= lds_in;
							END IF;
						WHEN "11" =>
							S_state <= "00";
						WHEN OTHERS => null;			
					END CASE;
			END IF;
		END IF;	
		IF reset='0' THEN
			as_e <= '1';
			rw_e <= '1';
			uds_e <= '1';
			lds_e <= '1';
			clkena_e <= '0';
		ELSIF rising_edge(clk28) THEN
			clkena_e <= '0';
        	IF ena7RDreg='1' THEN
				as_e <= '1';
				rw_e <= '1';
				uds_e <= '1';
				lds_e <= '1';
				CASE S_state IS
					WHEN "00" =>
						cpuIPL <= IPL;
						IF sel_bridge='1' THEN
							IF state/="01" THEN
								as_e <= '0';
							END IF;
							rw_e <= wr;
							IF wr='1' THEN
								uds_e <= uds_in;
								lds_e <= lds_in;					
							END IF;
						END IF;
					WHEN "01" =>
						as_e <= '0';
						rw_e <= wr;
						uds_e <= uds_in;
						lds_e <= lds_in;					
					WHEN "10" => rw_e <= wr;
						cpuIPL <= IPL;
						waitm <= dtack;
					WHEN OTHERS => --null;			
						clkena_e <= '1';
				END CASE;
			END IF;
		END IF;	
	END PROCESS;
	
	
-- SDRAM logic

ramcs <= '0' when sdram_req='1' and sel_fastram='1' and (cpu_rw='0' or cache_valid='0') else '1';
ramlds <= lds_in;
ramuds <= uds_in;
toram <= w_data;

-- We don't want chipram to be data-cacheable until
-- such time as the cache can bus-snoop.
cacheable<='1' when	sel_zorroii='1' or sel_zorroiii='1'  -- Fast RAM always cacheable
						or (sel_turbochip='1' and state="00")  -- Chip RAM only cacheable for instructions
							else '0';

-- Handle most logic on the falling edge of clk28,
-- handing 7Mhz cycles off to logic on the rising edge.
-- This allows us to unpause the CPU quicker
process(clk28)
begin
	if falling_edge(clk28) then
		fast_clkena<='0';
		if state/="01" and sel_fastram='1' and (cache_valid='0' or cpu_rw='0') then -- Trigger an SDRAM access
			sdram_req28<='1';
		end if;

		ac_req<='0';
		if state/="01" then
			if sel_autoconfig='1' then
				ac_req<='1';
				fast_clkena<='1';
			elsif sel_fastram='0' then
				sel_bridge<='1';
			end if;
		else
			fast_clkena<='1';
		end if;
		
		if clkena_e='1' then
			sel_bridge<='0';
		end if;

		-- When SDRAM access finishes, force the state machine back to the "run" state
		if sdram_req113='0' then
			sdram_req28<='0';
			fast_clkena<='1';
		end if;
			
	end if;
end process;	


-- Address decoding

sel_interrupt <= '1' when cpuaddr(31 downto 28)=X"F" else '0';
sel_32bit <= '0' when cpuaddr(31 downto 24)=X"00" else '1';
sel_chipram <= '1' when cpuaddr(31 downto 21)=X"00"&"111" else '0';
sel_autoconfig <= '1' when cpuaddr(23 downto 19)="11101" ELSE '0'; --$E80000 - $EFFFFF
sel_fastram <='1' when sel_zorroii='1' or sel_zorroiii='1' or sel_turbochip='1' else '0';

cpu_rw <= '0' when state="11" else '1';

process(clk)
begin
	if rising_edge(clk) then
		if sdram_req28='0' then
			sdram_req113<='1';
		end if;
		if ramready='1' then
			sdram_req113<='0';
		end if;
	end if;
end process;

sdram_req<=sdram_req28 and sdram_req113;



-- Autoconfig

autoconfig_zii : entity work.AutoconfigRAM(ZorroII)
port map(
	clk => clk28,
	reset_n => reset,
	addr_in => cpuaddr,
	data_in => w_data,
	data_out => ac_data1,
	config => fastramcfg(1 downto 0),
	rw => cpu_rw,
	req => ac_req,
	req_out => ac2_req,
	sel => sel_zorroii
);


autoconfig_ziii : entity work.AutoconfigRAM(ZorroIII)
port map(
	clk => clk28,
	reset_n => reset,
	addr_in => cpuaddr,
	data_in => w_data,
	data_out => ac_data2,
	config => '0'&fastramcfg(2),
	rw => cpu_rw,
	req => ac2_req,
	req_out => ac3_req,
	sel => sel_zorroiii
);


autoconfig_turbochip : entity work.AutoconfigRAM(TurboChip)
port map(
	clk => clk28,
	reset_n => reset,
	addr_in => cpuaddr,
	data_in => w_data,
	data_out => open, -- Not actually an autoconfig interface.
	config => '0'&turbochipram,
	rw => cpu_rw,
	req => ac3_req,
	req_out => open,
	sel => sel_turbochip
);

autoconfig_data<=ac_data1 and ac_data2;
	
END;	


