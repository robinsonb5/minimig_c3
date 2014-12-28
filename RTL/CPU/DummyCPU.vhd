
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity DummyCPU is
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
end DummyCPU;

architecture rtl of DummyCPU is

type states is (write1,write2,write3,write4,write5,write6,read1,read2);
signal state : states := read1;
signal counter : unsigned(15 downto 0);
signal temp : std_logic_vector(15 downto 0);
signal temp2 : std_logic_vector(15 downto 0);

begin

process(clk)
begin
	nResetOut<=nReset;
	if nReset='0' then
		state<=write1;
	elsif rising_edge(clk) then

		case state is

			when write1 =>
				data_write<=temp; -- std_logic_vector(counter);
				addr<=X"00DFF180";
				busstate<="11";	-- Write data
				state<=write2;
				nWR<='0';
				nUDS<='0';
				nLDS<='0';
				
			when write2 =>
				if clkena_in='1' then
					temp<=temp+1;
					state<=write3;
				end if;

			when write3 =>
				addr<=X"00BFE201";
				data_write<=X"0003"; -- Set OVL and LED as output
				nWR<='0';
				nUDS<='1';
				nLDS<='0';	-- Byte write to odd address.
				state<=write4;
				
			when write4 =>
				if clkena_in='1' then
					state<=write5;
				end if;
			
			when write5 =>
				addr<=X"00BFE001";
				data_write<=X"FFFF";
				data_write(1)<=temp2(6);	-- Echo mouse button status to keyboard LED.
				nWR<='0';
				nUDS<='1';
				nLDS<='0';	-- Byte write to odd address.
				state<=write6;
				
			when write6 =>
				if clkena_in='1' then
					state<=read1;
				end if;

			when read1 =>
				addr<=X"00BFE001";
				busstate<="10";	-- Read data
				state<=read2;
				nWR<='1';
				nUDS<='1';	-- Byte read from odd address.
				nLDS<='0';

			when read2 =>
				temp2<=data_in;
				if clkena_in='1' then
					state<=write1;
				end if;

		end case;
	end if;
end process;

end architecture;
