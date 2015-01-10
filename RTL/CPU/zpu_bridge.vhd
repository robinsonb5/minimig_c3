
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.zpupkg.ALL;


entity ZPU_Bridge is
	generic(
		SR_Read : integer:= 0;         --0=>user,   1=>privileged,      2=>switchable with CPU(0)
		VBR_Stackframe : integer:= 0;  --0=>no,     1=>yes/extended,    2=>switchable with CPU(0)
		extAddr_Mode : integer:= 0;    --0=>no,     1=>yes,    2=>switchable with CPU(1)
		MUL_Mode : integer := 0;	   --0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no MUL,  
		DIV_Mode : integer := 0;	   --0=>16Bit,  1=>32Bit,  2=>switchable with CPU(1),  3=>no DIV,  
		BitField : integer := 0		   --0=>no,     1=>yes,    2=>switchable with CPU(1)  
		);
   port(clk               	: in std_logic;
        nReset             	: in std_logic;			--low active
        clkena_in         	: in std_logic:='1';
        data_in          	: in std_logic_vector(15 downto 0);
		IPL				  	: in std_logic_vector(2 downto 0):="111";
		IPL_autovector   	: in std_logic:='0';
		CPU             	: in std_logic_vector(1 downto 0):="00";  -- 00->68000  01->68010  11->68020(only some parts - yet)
        addr           		: buffer std_logic_vector(31 downto 0);
        data_write        	: out std_logic_vector(15 downto 0);
		nWr			  		: out std_logic;
		nUDS, nLDS	  		: out std_logic;
		busstate	  	  	: out std_logic_vector(1 downto 0);	-- 00-> fetch code 10->read data 11->write data 01->no memaccess
		nResetOut	  		: out std_logic;
        FC              	: out std_logic_vector(2 downto 0);
-- for debug		
		skipFetch	  		: out std_logic;
        regin          		: buffer std_logic_vector(31 downto 0)
        );
end ZPU_Bridge;

architecture rtl of ZPU_Bridge is

type bridgestates is (waiting,readlow,readhigh,writelow,writehigh);
signal state : bridgestates;

constant maxAddrBit : integer := 31;

signal mem_busy           : std_logic;
signal mem_read             : std_logic_vector(wordSize-1 downto 0);
signal mem_write            : std_logic_vector(wordSize-1 downto 0);
signal mem_addr             : std_logic_vector(maxAddrBit downto 0);
signal mem_writeEnable      : std_logic; 
signal mem_hEnable      : std_logic; 
signal mem_bEnable      : std_logic; 
signal mem_readEnable       : std_logic;
--signal mem_writeMask        : std_logic_vector(wordBytes-1 downto 0);
signal zpu_enable               : std_logic;
signal zpu_interrupt            : std_logic;
signal zpu_break                : std_logic;
signal zpu_to_rom : ZPU_ToROM;
signal zpu_from_rom : ZPU_FromROM;

signal read_pending : std_logic;
signal write_pending : std_logic;
signal b_enable : std_logic;
signal h_enable : std_logic;

begin

	myrom : entity work.MinimigTest_ROM
	generic map
	(
		maxAddrBitBRAM => 12
	)
	port map (
		clk => clk,
		from_zpu => zpu_to_rom,
		to_zpu => zpu_from_rom
	);

	zpu: zpu_core_flex 
	generic map (
		IMPL_MULTIPLY => true,
		IMPL_COMPARISON_SUB => true,
		IMPL_EQBRANCH => true,
		IMPL_STOREBH => true,
		IMPL_LOADBH => true,
		IMPL_CALL => true,
		IMPL_SHIFT => true,
		IMPL_XOR => true,
		REMAP_STACK => true,
		EXECUTE_RAM => true
--		stackbit => 24
	)
	port map (
		clk                 => clk,
		reset               => not nReset,
		enable              => zpu_enable,
		in_mem_busy         => mem_busy,
		mem_read            => mem_read,
		mem_write           => mem_write,
		out_mem_addr        => mem_addr,
		out_mem_writeEnable => mem_writeEnable,
		out_mem_hEnable     => mem_hEnable,
		out_mem_bEnable     => mem_bEnable,
		out_mem_readEnable  => mem_readEnable,
--		mem_writeMask       => mem_writeMask,
		interrupt           => zpu_interrupt,
		break               => zpu_break,
		from_rom => zpu_from_rom,
		to_rom => zpu_to_rom
	);
	
zpu_enable<='1';
zpu_interrupt<='0';

process(clk)
begin
	nResetOut<=nReset;
	if nReset='0' then
		state<=waiting;
		busstate<="01"; -- Do nothing
		write_pending<='0';
		read_pending<='0';
	elsif rising_edge(clk) then

		mem_busy<='1';

		if mem_writeEnable='1' then -- Latch write and b/h enable signals.
			write_pending<='1';
			b_enable<=mem_bEnable;
			h_enable<=mem_hEnable;
		end if;
		if mem_readEnable='1' then -- Latch read and b/h enable signals.
			read_pending<='1';
			b_enable<=mem_bEnable;
			h_enable<=mem_hEnable;
		end if;			

		addr(31 downto 24)<=(others => '0');
		
		case state is
			when waiting =>
				if clkena_in='1' then -- Sync with toplevel state machine
					busstate<="01"; -- Do nothing
					if write_pending='1' then
						write_pending<='0';
						-- Trigger write of either high word, or single word if half or byte cycle.

						if mem_hEnable='1' then	-- Halfword cycle
							addr(23 downto 0)<=mem_addr(23 downto 0); -- For halfword or byte writes we use the address unmodified
							data_write<=mem_write(15 downto 0);
							nUDS<='0';
							nLDS<='0';
							state<=writelow;
							
						elsif mem_bEnable='1' then -- Byte cycle
							addr(23 downto 0)<=mem_addr(23 downto 0); -- For halfword or byte writes we use the address unmodified
							data_write<=mem_write(7 downto 0)&mem_write(7 downto 0);
							nUDS<=mem_addr(0);
							nLDS<=not mem_addr(0);
							state<=writelow;
							
						else	-- longword cycle.
--							addr<=mem_addr(31 downto 2)&"00"; -- longword writes are 32-bit aligned to make the logic simpler
							addr(23 downto 0)<=mem_addr(23 downto 1)&'0'; -- longword writes are now word-aligned.
							data_write<=mem_write(31 downto 16);
							nUDS<='0';
							nLDS<='0';
							state<=writehigh;
						end if;

						nWR<='0';
						busstate<="11"; -- Write data
					
					elsif read_pending='1' then
						read_pending<='0';
						-- Trigger read of either high word, or single word if half or byte cycle.
						if mem_hEnable='1' then	-- Halfword cycle
							addr(23 downto 0)<=mem_addr(23 downto 0); -- For halfword or byte reads we use the address unmodified
							mem_read(31 downto 16)<=(others=>'0');
							nUDS<='0';
							nLDS<='0';
							state<=readlow;						
						elsif mem_bEnable='1' then -- Byte cycle
							addr(23 downto 0)<=mem_addr(23 downto 0); -- For halfword or byte reads we use the address unmodified
							mem_read(31 downto 8)<=(others=>'0');
							nUDS<=mem_addr(0);
							nLDS<=not mem_addr(0);
							state<=readlow;
						else	-- longword cycle.
							addr(23 downto 0)<=mem_addr(23 downto 1)&'0'; -- longword writes are now word-aligned
							nUDS<='0';
							nLDS<='0';
							state<=readhigh;
						end if;
						nWR<='1';
						busstate<="10"; -- Read data
					
					end if;
				end if;

			when readhigh =>
				if clkena_in='1' then
					mem_read(31 downto 16)<=data_in;
					addr(23 downto 0)<=(mem_addr(23 downto 1)&'0')+2; -- Adjust address for second word
--					addr(1)<='1'; -- Adjust address for second word
					state<=readlow;
				end if;

			when readlow =>
				if clkena_in='1' then
					if mem_bEnable='1' then -- A byte operation?
						if mem_addr(0)='1' then -- Odd address?
							mem_read(7 downto 0)<=data_in(7 downto 0);
						else
							mem_read(7 downto 0)<=data_in(15 downto 8);
						end if;
					else
						mem_read(15 downto 0)<=data_in;
					end if;
					busstate<="01"; -- Do nothing
					mem_busy<='0';	-- Allow ZPU to continue
					state<=waiting;
				end if;
			
			when writehigh =>
				if clkena_in='1' then
					addr(23 downto 0)<=(mem_addr(23 downto 1)&'0')+2; -- Adjust address for second word
--					addr(1)<='1'; -- Adjust address for second word
					data_write<=mem_write(15 downto 0);
					state<=writelow;
				end if;
			
			when writelow =>
				if clkena_in='1' then
					busstate<="01"; -- Do nothing
					nWR<='1';
					mem_busy<='0';	-- Allow ZPU to continue
					state<=waiting;
				end if;
		end case;
	end if;
end process;

end architecture;
