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

-- Annotations by Alastair M. Robinson, March 2012

-- TG68K.vhd provides an interface between the core of the processor itself
-- (TG68KdotC_Kernel) and the rest of the Minimig.

-- The kernel is similar to a "real" 68000; it lacks a few key signals, such as
-- the address strobe signal, _dtack, and the Bus Request / Bus Grant signals
-- Wait states and bus arbitration are instead handled by freezing
-- the processor by pulling the clkena_in signal low.  (Similar to 68K Halt signal,
-- but input-only.)

-- TG68K is a wrapper that provides the missing logic signals needed by Minimig,
-- (i.e. _as, _dtack) and also provides a separate address/data bus for Fast RAM,
-- and signals through which the Minimig can configure the CPU. 

-- Also provided is AutoConfig data for the FastRAM expansion.

-- FIXME - replace fast_sel with a more general sel_zorro signal
-- TODO:

--	Done	Route chipmem access away from the Minimig in '020 mode for speed?
--			(Must take care to enable this only after ROM shadowing has finished...)

--			Turbo ROM - route Kickstart away from Minimig?

--			Or maybe use a chipram shadow at, say, 0x01000000 - 0x011fffff

--       Another 4 megs of Fast RAM maybe? (0x1c00000 - 0x1ffffff?)



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TG68K is
   port(        
		clk           : in std_logic;	-- Sysclk - ~113MHz
		reset         : in std_logic;
        clkena_in     : in std_logic:='1';  -- Tied high in Minimig design
		  
		  -- Standard MC68000 signals...
		  
        IPL           : in std_logic_vector(2 downto 0):="111";	-- Interrupt Priority Level - active low?
        dtack         : in std_logic;	-- Data Transfer Acknowledge.  Low state indicates cycle finished.

        vpa           : in std_logic:='1';  -- Valid Peripheral Address - Autovector, active low? Permamently high in Minimig design
        ein           : in std_logic:='1';  -- Why do we need e as an input?  It's not bidir on real chip
														  -- (Both tied to VCC in Minimig design)

        addr          : buffer std_logic_vector(31 downto 0);
        data_read  	  : in std_logic_vector(15 downto 0);
        data_write 	  : out std_logic_vector(15 downto 0);
        as            : out std_logic;	-- Address strobe, active low?
        uds           : out std_logic; -- Upper data strobe, active low?
        lds           : out std_logic; -- lower data strobe, active low?
        rw            : out std_logic; -- 1 for Read, 0 for Write
        e             : out std_logic; -- 6800-style IO enable, active high
													-- Unconnected in Minimig design
        vma           : buffer std_logic:='1';	-- Valid Memory Address (for 6800 peripherals)
																-- Unconnected in Minimig design

		  -- TG68 specific signals...
		  
        wrd           : out std_logic;
        ena7RDreg      : in std_logic:='1';	-- set by SDRAM Controller
        ena7WRreg      : in std_logic:='1';	-- set by SDRAM Controller
        enaWRreg      : in std_logic:='1';	-- set by SDRAM Controller
        
        fromram    	  : in std_logic_vector(15 downto 0);	-- Data input from SDRAM controller
        ramready      : in std_logic:='0';						-- Ready signal from SDRAM controller
        cpu           : in std_logic_vector(1 downto 0);		-- From minimig, selects between 68000/10/20.
        memcfg           : in std_logic_vector(5 downto 0); -- From Minimig, used to configure fastram
        ramaddr    	  : out std_logic_vector(31 downto 0); -- Address output to SDRAM controller
        cpustate      : out std_logic_vector(5 downto 0);	-- Used by SDRAM controller

		  nResetOut	  : out std_logic;
        skipFetch     : buffer std_logic;	-- n/c in Minimig
        cpuDMA         : buffer std_logic;	-- Used by SDRAM controller
        ramlds        : out std_logic;	-- Lower DS for SDRAM controller
        ramuds        : out std_logic	-- Upper DS for SDRAM controller
        );
end TG68K;

ARCHITECTURE logic OF TG68K IS

-- Interface description for the core of the processor.
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
   SIGNAL t_addr      : std_logic_vector(31 downto 0);	-- Translated address?  Temp address?
--   SIGNAL data_write  : std_logic_vector(15 downto 0);
--   SIGNAL t_data      : std_logic_vector(15 downto 0);
   SIGNAL r_data      : std_logic_vector(15 downto 0);	-- Data in from Agnus.
	SIGNAL w_data		 : std_logic_vector(15 downto 0);	-- Data out from the kernel
   SIGNAL cpuIPL      : std_logic_vector(2 downto 0);	-- Interrupt level
	-- FIXME what do the _s and _e values signify?
   SIGNAL addr_akt_s  : std_logic;
   SIGNAL addr_akt_e  : std_logic;
   SIGNAL data_akt_s  : std_logic;
   SIGNAL data_akt_e  : std_logic;
   SIGNAL as_s        : std_logic;
   SIGNAL as_e        : std_logic;
   SIGNAL uds_s       : std_logic;
   SIGNAL uds_e       : std_logic;
   SIGNAL lds_s       : std_logic;
   SIGNAL lds_e       : std_logic;
   SIGNAL rw_s        : std_logic;
   SIGNAL rw_e        : std_logic;
   SIGNAL vpad        : std_logic;
   SIGNAL waitm       : std_logic;	-- Wait memory?  
   SIGNAL clkena_e    : std_logic;
   SIGNAL S_state     : std_logic_vector(1 downto 0);
   SIGNAL S_stated     : std_logic_vector(1 downto 0);
-- SIGNAL decode	  : std_logic;
   SIGNAL wr	      : std_logic;
   SIGNAL uds_in	  : std_logic;
   SIGNAL lds_in	  : std_logic;
   SIGNAL state       : std_logic_vector(1 downto 0);  -- 00-> fetch code 10->read data 11->write data 01->no memaccess (setup address?)
   SIGNAL clkena	  : std_logic;
--   SIGNAL n_clk		  : std_logic;
   SIGNAL vmaena	  : std_logic;
   SIGNAL vmaenad	  : std_logic;
   SIGNAL state_ena	  : std_logic;	-- 1 during TG68 instruction phase when the processor is off the bus (state 01)
   SIGNAL sync_state3 : std_logic;
   SIGNAL eind	      : std_logic;
   SIGNAL eindd	      : std_logic;
   SIGNAL sel_autoconfig: std_logic;
   SIGNAL autoconfig_out: std_logic;
   SIGNAL autoconfig_data: std_logic_vector(3 downto 0);
   SIGNAL sel_fast: std_logic;
	SIGNAL sel_chipram: std_logic;
	SIGNAL turbo_chipram : std_logic;
	SIGNAL sel_akiko: std_logic;
	SIGNAL sel_zorro: std_logic;  -- Aggregrate signal indicates that cycle need not concern the Minimig
	SIGNAL akiko_data: std_logic_vector(15 downto 0);
   SIGNAL slower       : std_logic_vector(3 downto 0);


	type sync_states is (sync0, sync1, sync2, sync3, sync4, sync5, sync6, sync7, sync8, sync9);
	signal sync_state		: sync_states;
	
   SIGNAL datatg68      : std_logic_vector(15 downto 0);	-- Data being supplied to the TG68 kernel
   SIGNAL ramcs	      : std_logic;

BEGIN 
	sel_zorro <= sel_fast or sel_akiko;
--	n_clk <= NOT clk;
--	wrd <= data_akt_e OR data_akt_s;
	wrd <= wr;
	addr <= cpuaddr;-- WHEN addr_akt_e='1' ELSE t_addr WHEN addr_akt_s='1' ELSE "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
--	data <= data_write WHEN data_akt_e='1' ELSE t_data WHEN data_akt_s='1' ELSE "ZZZZZZZZZZZZZZZZ";
--	datatg68 <= fromram WHEN sel_fast='1' ELSE r_data; 
--	datatg68 <= fromram WHEN sel_fast='1' ELSE r_data WHEN sel_autoconfig='0' ELSE autoconfig_data&r_data(11 downto 0); 
	data_write <= w_data;
	datatg68 <= fromram WHEN sel_fast='1'
		ELSE autoconfig_data&r_data(11 downto 0) when sel_autoconfig='1'
		else akiko_data when sel_akiko='1'
		else r_data;
--	toram <= data_write;
	
   sel_autoconfig <= '1' when cpuaddr(23 downto 19)="11101" AND autoconfig_out='1' ELSE '0'; --$E80000 - $EFFFFF
	sel_chipram <= '1' when state/="01" AND (cpuaddr(23 downto 21)="000") ELSE '0'; --$000000 - $1FFFFF

	sel_fast <= '1' when state/="01" AND
		(
			( turbo_chipram='1' AND cpuaddr(23 downto 21)="000" ) OR
			cpuaddr(23 downto 21)="001" OR
			cpuaddr(23 downto 21)="010" OR
			cpuaddr(23 downto 21)="011" OR
			cpuaddr(23 downto 21)="100"
		)
		ELSE '0'; --$200000 - $9FFFFF

		sel_akiko <= '1' when cpuaddr(23 downto 16)="10111000" else '0'; -- $B80000

--	sel_fast <= '1' when cpuaddr(23 downto 21)="001" OR cpuaddr(23 downto 21)="010" ELSE '0'; --$200000 - $5FFFFF
--	sel_fast <= '1' when cpuaddr(23 downto 19)="11111" ELSE '0'; --$F800000;
--	sel_fast <= '0'; --$200000 - $9FFFFF
--	sel_fast <= '1' when cpuaddr(24)='1' AND state/="01" ELSE '0'; --$1000000 - $1FFFFFF
	ramcs <= NOT sel_fast;-- OR (state(0) AND NOT state(1));	-- Active low _CS signal?
--	cpuDMA <= NOT ramcs;
	cpuDMA <= sel_fast;	-- Used purely by the SDRAM controller
	cpustate <= clkena&slower(1 downto 0)&ramcs&state;
	ramlds <= lds_in;
	ramuds <= uds_in;
	ramaddr(23 downto 0) <= cpuaddr(23 downto 0);
	ramaddr(24) <= sel_fast and not sel_chipram;
	ramaddr(31 downto 25) <= cpuaddr(31 downto 25);


pf68K_Kernel_inst: TG68KdotC_Kernel 
	generic map(
		SR_Read => 2,         	--0=>user,   1=>privileged,      2=>switchable with CPU(0)
		VBR_Stackframe => 2,  	--0=>no,     1=>yes/extended,    2=>switchable with CPU(0)
		extAddr_Mode => 2,    	--0=>no,     1=>yes,    2=>switchable with CPU(1)
		MUL_Mode => 2,	   		--0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no MUL,  
		DIV_Mode => 2		  	 --0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no DIV,  
		)
  PORT MAP(
        clk => clk,               	-- : in std_logic;
        nReset => reset,            -- : in std_logic:='1';			--low active
        clkena_in => clkena,	        -- : in std_logic:='1';
--        data_in => r_data,       -- : in std_logic_vector(15 downto 0);
--        data_in => data_read,       -- : in std_logic_vector(15 downto 0);
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
 
	PROCESS (clk)
	BEGIN
		autoconfig_data <= "1111";
		IF memcfg(5 downto 4)/="00" THEN
			CASE cpuaddr(6 downto 1) IS
				WHEN "000000" => autoconfig_data <= "1110";		--normal card, add mem, no ROM
				WHEN "000001" => 
					CASE memcfg(5 downto 4) IS 
						WHEN "01" => autoconfig_data <= "0110";		--2MB
						WHEN "10" => autoconfig_data <= "0111";		--4MB
						WHEN OTHERS => autoconfig_data <= "0000";	--8MB
					END CASE;	
				WHEN "001000" => autoconfig_data <= "1110";		--4626=icomp
				WHEN "001001" => autoconfig_data <= "1101";		
				WHEN "001010" => autoconfig_data <= "1110";		
				WHEN "001011" => autoconfig_data <= "1101";		
				WHEN "010011" => autoconfig_data <= "1110";		--serial=1
				WHEN OTHERS => null;
			END CASE;	
		END IF;
		IF rising_edge(clk) THEN
			IF reset='0' THEN
				autoconfig_out <= '1';		--autoconfig on
				turbo_chipram <= '0';	-- disable turbo_chipram until we know kickstart's running...
			ELSIF enaWRreg='1' THEN
				IF sel_autoconfig='1' AND state="11"AND uds_in='0' AND cpuaddr(6 downto 1)="100100" THEN
					autoconfig_out <= '0';		--autoconfig off
					turbo_chipram <= cpu(1);	-- enable turbo_chipram after autoconfig has been done...
													-- DONE - make this dependent upon CPU type?
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset='0' THEN
				vmaena <= '0';
				vmaenad <= '0';
				sync_state3 <= '0';
			ELSIF ena7RDreg='1' THEN
				vmaena <= '0';
				sync_state3 <= '0';
				IF state/="01" OR state_ena='1' THEN
					vmaenad <= vmaena;
				END IF;
				IF sync_state=sync5 THEN
					e <= '1';
				END IF;
				IF sync_state=sync3 THEN
					sync_state3 <= '1';
				END IF;
				IF sync_state=sync9 THEN
					e <= '0';
					vmaena <= NOT vma;
				END IF;
			END IF;
		END IF;	
		IF rising_edge(clk) THEN
			S_stated <= S_state;
			IF ena7WRreg='1' THEN
				eind <= ein;
				eindd <= eind;
				CASE sync_state IS
					WHEN sync0  => sync_state <= sync1;
					WHEN sync1  => sync_state <= sync2;
					WHEN sync2  => sync_state <= sync3;
					WHEN sync3  => sync_state <= sync4;
								   vma <= vpa;
					WHEN sync4  => sync_state <= sync5;
					WHEN sync5  => sync_state <= sync6;
					WHEN sync6  => sync_state <= sync7;
					WHEN sync7  => sync_state <= sync8;
					WHEN sync8  => sync_state <= sync9;
					WHEN OTHERS => sync_state <= sync0;
								   vma <= '1';
				END CASE;	
				IF eind='1' AND eindd='0' THEN
					sync_state <= sync7;
				END IF;			
			END IF;	
		END IF;	
	END PROCESS;
				
	
	PROCESS (clk)
	BEGIN
		state_ena <= '0';
		-- Clock is enabled when:
		-- clkena_in=1 (permanently the case in Minimig design)
		--	AND
		-- enaWRreg=1 
		-- AND
		-- (
		-- 	state="01" - TG68 instruction phase in which no data transfer takes place
		-- 	OR
		--		(
		-- 		ena7RDreg=1
		--			AND
		--			clkena_e=1
		--		)
		--		OR
		--		ramready=1
		--		OR
		--		sel_akiko=1  -- FIXME - should be sel_zorro, but not fastram.  So exclude fastram from zorro?
		--	)
		IF clkena_in='1' AND enaWRreg='1' AND (state="01" OR (ena7RDreg='1' AND clkena_e='1')
			OR ramready='1' OR sel_akiko='1') THEN
			clkena <= '1';
		ELSE 
			clkena <= '0';
		END IF;	
		IF state="01" THEN
			state_ena <= '1';
		END IF;	
		IF rising_edge(clk) THEN
        	IF clkena='1' THEN
				slower <= "1000";
			ELSE 
				slower(3 downto 0) <= enaWRreg&slower(3 downto 1);
--				slower(0) <= NOT slower(3) AND NOT slower(2);
			END IF;	
		END IF;	
	END PROCESS;
				
PROCESS (clk, reset, state, as_s, as_e, rw_s, rw_e, uds_s, uds_e, lds_s, lds_e)
	BEGIN
		IF state="01" THEN -- No memory access on this cycle...
			as <= '1';
			rw <= '1';
			uds <= '1';
			lds <= '1';
		ELSE
			as <= (as_s AND as_e) OR sel_zorro; -- _as is held inactive for Zorro II cycles, since Minimig doesn't need to know about them.
			rw <= rw_s AND rw_e;	-- Are "e" signals "enable"?  If so, why AND, not OR, since these are active low?
			uds <= uds_s AND uds_e;
			lds <= lds_s AND lds_e;
		END IF;
		IF reset='0' THEN
			S_state <= "00";
			as_s <= '1';
			rw_s <= '1';
			uds_s <= '1';
			lds_s <= '1';
			addr_akt_s <= '0';
			data_akt_s <= '0';
		ELSIF rising_edge(clk) THEN
        	IF ena7WRreg='1' THEN	-- What's ena7WRreg?  "s" versions of signals come from this block
											-- The combination of "e" and "s" signals may be a timing fix of some kind?
				as_s <= '1';
				rw_s <= '1';
				uds_s <= '1';
				lds_s <= '1';
				addr_akt_s <= '0';
				data_akt_s <= '0';
					CASE S_state IS
						WHEN "00" => IF state/="01" AND sel_zorro='0' THEN -- Memory cycle not destined for ZorroII?
										 uds_s <= uds_in;	-- Pass UDS and LDS onto the Minimig bus.
										 lds_s <= lds_in;
										S_state <= "01";
									 END IF;
						WHEN "01" => as_s <= '0';	-- Assert Address Strobe
									 rw_s <= wr;		-- Pass through r_w to Minimig...
									 uds_s <= uds_in;	-- and uds/lds
									 lds_s <= lds_in;
									 S_state <= "10";
									 t_addr <= cpuaddr;	-- and now the address from the kernel
--									 t_data <= data_write;
						WHEN "10" =>
									 addr_akt_s <= '1';
									 data_akt_s <= NOT wr;	-- 0 for read, 1 for write
									 r_data <= data_read;	-- r_data fetched from Minimig bus
									 IF waitm='0' OR (vma='0' AND sync_state=sync9) THEN
										S_state <= "11";
									 ELSE		-- Wait state...
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
			addr_akt_e <= '0';
			data_akt_e <= '0';
		ELSIF rising_edge(clk) THEN
        	IF ena7RDreg='1' THEN	-- ...and what's ena7RDreg?  Why do "e" versions of the signals come from here?
				as_e <= '1';
				rw_e <= '1';
				uds_e <= '1';
				lds_e <= '1';
				clkena_e <= '0';	-- Freeze processor (only effective while ena7RDreg is active)...
				addr_akt_e <= '0';
				data_akt_e <= '0';
				CASE S_state IS
					WHEN "00" => addr_akt_e <= '1';	-- Analogue of _as maybe?
								 cpuIPL <= IPL;	-- Forward IPL signals from Minimig to Processor
								 IF sel_zorro='0' THEN	-- Not a ZorroII cycle...
									 IF state/="01" THEN	-- and a cycle in which memory transfer occurs...
										as_e <= '0';	-- Force address strobe
									 END IF;
									 rw_e <= wr;	-- forward r_w signal
									 data_akt_e <= NOT wr;
									 IF wr='1' THEN	-- Read cycle?
										 uds_e <= uds_in;
										 lds_e <= lds_in;					
									 END IF;
								 END IF;
					WHEN "01" => addr_akt_e <= '1';
								 data_akt_e <= NOT wr;
									as_e <= '0';
									 rw_e <= wr;
									 uds_e <= uds_in;
									 lds_e <= lds_in;					
					WHEN "10" => rw_e <= wr;
								 addr_akt_e <= '1';
								 data_akt_e <= NOT wr;
								 cpuIPL <= IPL;
								 waitm <= dtack;
					WHEN OTHERS => --null;			
								 clkena_e <= '1';	-- Allow clock to run
				END CASE;
			END IF;
		END IF;	
	END PROCESS;

myAkiko2: entity work.akiko2
	port map(
		clk => clk,
		reset => reset,
		address_in => cpuaddr(7 downto 2),
		data_in => w_data,
		data_out => akiko_data,
		wr => wr,
		hds => uds_in,
		lds => lds_in,
		sel_akiko => sel_akiko
	);	

END;	
