-- ZPU
--
-- Copyright 2004-2008 oharboe - �yvind Harboe - oyvind.harboe@zylin.com
-- Modified by Alastair M. Robinson for the ZPUFlex project.
--
-- The FreeBSD license
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above
--    copyright notice, this list of conditions and the following
--    disclaimer in the documentation and/or other materials
--    provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE ZPU PROJECT ``AS IS'' AND ANY
-- EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
-- ZPU PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
-- INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
-- ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- The views and conclusions contained in the software and documentation
-- are those of the authors and should not be interpreted as representing
-- official policies, either expressed or implied, of the ZPU Project.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.zpu_config.all;
use work.zpupkg.all;

entity DiagROM_ROM is
generic
	(
		maxAddrBitBRAM : integer := maxAddrBitBRAMLimit -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	areset : in std_logic := '0';
	from_zpu : in ZPU_ToROM;
	to_zpu : out ZPU_FromROM
);
end DiagROM_ROM;

architecture arch of DiagROM_ROM is

type ram_type is array(natural range 0 to ((2**(maxAddrBitBRAM+1))/4)-1) of std_logic_vector(wordSize-1 downto 0);

shared variable ram : ram_type :=
(
     0 => x"84808080",
     1 => x"ed040000",
     2 => x"00000000",
     3 => x"84808080",
     4 => x"880d8004",
     5 => x"84808080",
     6 => x"940471fd",
     7 => x"06087283",
     8 => x"06098105",
     9 => x"8205832b",
    10 => x"2a83ffff",
    11 => x"06520471",
    12 => x"fc060872",
    13 => x"83060981",
    14 => x"05830510",
    15 => x"10102a81",
    16 => x"ff065204",
    17 => x"71fc0608",
    18 => x"84808086",
    19 => x"cc738306",
    20 => x"10100508",
    21 => x"067381ff",
    22 => x"06738306",
    23 => x"09810583",
    24 => x"05101010",
    25 => x"2b0772fc",
    26 => x"060c5151",
    27 => x"04028405",
    28 => x"84808080",
    29 => x"880c8480",
    30 => x"8080940b",
    31 => x"84808081",
    32 => x"84040000",
    33 => x"02fc050d",
    34 => x"84808086",
    35 => x"dc518480",
    36 => x"80819a2d",
    37 => x"84808081",
    38 => x"940402d8",
    39 => x"050d7b59",
    40 => x"78802e90",
    41 => x"38788480",
    42 => x"8086fc0c",
    43 => x"800b8480",
    44 => x"8087840c",
    45 => x"84808087",
    46 => x"84085271",
    47 => x"81f13884",
    48 => x"808086fc",
    49 => x"08841184",
    50 => x"808086fc",
    51 => x"0c700884",
    52 => x"80808780",
    53 => x"0c518112",
    54 => x"83068480",
    55 => x"80878008",
    56 => x"70982c53",
    57 => x"5653800b",
    58 => x"84808086",
    59 => x"fc085354",
    60 => x"70802eaf",
    61 => x"38728480",
    62 => x"8087840c",
    63 => x"81145472",
    64 => x"818e3871",
    65 => x"84137108",
    66 => x"84808087",
    67 => x"800c8115",
    68 => x"83068480",
    69 => x"80878008",
    70 => x"70982c55",
    71 => x"53555355",
    72 => x"70d33871",
    73 => x"84808086",
    74 => x"fc0c8214",
    75 => x"70812a73",
    76 => x"59555890",
    77 => x"0b86e980",
    78 => x"8423a081",
    79 => x"0b86e980",
    80 => x"802386e9",
    81 => x"80802251",
    82 => x"800b86e9",
    83 => x"80802386",
    84 => x"e9808022",
    85 => x"52800b86",
    86 => x"e9808023",
    87 => x"86e98080",
    88 => x"227083ff",
    89 => x"ff067288",
    90 => x"2a708106",
    91 => x"51535152",
    92 => x"70802e8f",
    93 => x"3875802e",
    94 => x"81be3871",
    95 => x"8280862e",
    96 => x"80db3891",
    97 => x"0b86e980",
    98 => x"84238480",
    99 => x"8082b304",
   100 => x"74882b84",
   101 => x"80808780",
   102 => x"0c811383",
   103 => x"06848080",
   104 => x"87800870",
   105 => x"982c5356",
   106 => x"53848080",
   107 => x"82a00484",
   108 => x"80808780",
   109 => x"08882b84",
   110 => x"80808780",
   111 => x"0c811283",
   112 => x"06848080",
   113 => x"87800870",
   114 => x"982c5356",
   115 => x"53800b84",
   116 => x"808086fc",
   117 => x"08535484",
   118 => x"808081f0",
   119 => x"048056fe",
   120 => x"d5ca0b86",
   121 => x"e9808023",
   122 => x"86e98080",
   123 => x"2251810b",
   124 => x"86e98080",
   125 => x"2386e980",
   126 => x"80225175",
   127 => x"86e98080",
   128 => x"2386e980",
   129 => x"80225177",
   130 => x"86e98080",
   131 => x"2386e980",
   132 => x"80225175",
   133 => x"86e98080",
   134 => x"2386e980",
   135 => x"80225175",
   136 => x"86e98080",
   137 => x"2386e980",
   138 => x"80225191",
   139 => x"0b86e980",
   140 => x"84238480",
   141 => x"8082b304",
   142 => x"73828080",
   143 => x"07517072",
   144 => x"2e098106",
   145 => x"febd3879",
   146 => x"10587880",
   147 => x"2e81f038",
   148 => x"78768480",
   149 => x"8087840c",
   150 => x"57848080",
   151 => x"87840852",
   152 => x"7181b538",
   153 => x"76841871",
   154 => x"08848080",
   155 => x"87800c81",
   156 => x"14830684",
   157 => x"80808784",
   158 => x"0c848080",
   159 => x"87800870",
   160 => x"982cff1c",
   161 => x"54555658",
   162 => x"5372ff2e",
   163 => x"80cb3871",
   164 => x"86e98080",
   165 => x"3486e980",
   166 => x"80335171",
   167 => x"802eae38",
   168 => x"84808087",
   169 => x"84085271",
   170 => x"80ca3876",
   171 => x"84187108",
   172 => x"84808087",
   173 => x"800c8114",
   174 => x"83068480",
   175 => x"8087840c",
   176 => x"84808087",
   177 => x"80087098",
   178 => x"2c555258",
   179 => x"54ff1353",
   180 => x"72ff2e09",
   181 => x"8106ffb7",
   182 => x"38768480",
   183 => x"8086fc0c",
   184 => x"910b86e9",
   185 => x"80842381",
   186 => x"0b848080",
   187 => x"86ec0c02",
   188 => x"a8050d04",
   189 => x"73882b84",
   190 => x"80808780",
   191 => x"0c811283",
   192 => x"06848080",
   193 => x"87840c84",
   194 => x"80808780",
   195 => x"0870982c",
   196 => x"53548480",
   197 => x"8085cd04",
   198 => x"74882b84",
   199 => x"80808780",
   200 => x"0c811283",
   201 => x"06848080",
   202 => x"87840c84",
   203 => x"80808780",
   204 => x"0870982c",
   205 => x"ff1a5553",
   206 => x"54848080",
   207 => x"85890472",
   208 => x"84808087",
   209 => x"840c8480",
   210 => x"8084d904",
   211 => x"00ffffff",
   212 => x"ff00ffff",
   213 => x"ffff00ff",
   214 => x"ffffff00",
   215 => x"48656c6c",
   216 => x"6f2c2077",
   217 => x"6f726c64",
   218 => x"210a0064",
	others => x"00000000"
);

begin

process (clk)
begin
	if (clk'event and clk = '1') then
		if (from_zpu.memAWriteEnable = '1') and (from_zpu.memBWriteEnable = '1') and (from_zpu.memAAddr=from_zpu.memBAddr) and (from_zpu.memAWrite/=from_zpu.memBWrite) then
			report "write collision" severity failure;
		end if;
	
		if (from_zpu.memAWriteEnable = '1') then
			ram(to_integer(unsigned(from_zpu.memAAddr(maxAddrBitBRAM downto 2)))) := from_zpu.memAWrite;
			to_zpu.memARead <= from_zpu.memAWrite;
		else
			to_zpu.memARead <= ram(to_integer(unsigned(from_zpu.memAAddr(maxAddrBitBRAM downto 2))));
		end if;
	end if;
end process;

process (clk)
begin
	if (clk'event and clk = '1') then
		if (from_zpu.memBWriteEnable = '1') then
			ram(to_integer(unsigned(from_zpu.memBAddr(maxAddrBitBRAM downto 2)))) := from_zpu.memBWrite;
			to_zpu.memBRead <= from_zpu.memBWrite;
		else
			to_zpu.memBRead <= ram(to_integer(unsigned(from_zpu.memBAddr(maxAddrBitBRAM downto 2))));
		end if;
	end if;
end process;


end arch;

