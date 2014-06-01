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
    19 => x"d0738306",
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
    35 => x"e0518480",
    36 => x"80819a2d",
    37 => x"84808081",
    38 => x"940402d8",
    39 => x"050d7b59",
    40 => x"78802e90",
    41 => x"38788480",
    42 => x"8087800c",
    43 => x"800b8480",
    44 => x"8087880c",
    45 => x"84808087",
    46 => x"88085271",
    47 => x"81f33884",
    48 => x"80808780",
    49 => x"08841184",
    50 => x"80808780",
    51 => x"0c700884",
    52 => x"80808784",
    53 => x"0c518112",
    54 => x"83068480",
    55 => x"80878408",
    56 => x"70982c53",
    57 => x"5653800b",
    58 => x"84808087",
    59 => x"80085354",
    60 => x"70802eaf",
    61 => x"38728480",
    62 => x"8087880c",
    63 => x"81145472",
    64 => x"81903871",
    65 => x"84137108",
    66 => x"84808087",
    67 => x"840c8115",
    68 => x"83068480",
    69 => x"80878408",
    70 => x"70982c55",
    71 => x"53555355",
    72 => x"70d33871",
    73 => x"84808087",
    74 => x"800c8214",
    75 => x"58817871",
    76 => x"2a735858",
    77 => x"54900b86",
    78 => x"e9808423",
    79 => x"a0810b86",
    80 => x"e9808023",
    81 => x"86e98080",
    82 => x"2251800b",
    83 => x"86e98080",
    84 => x"2386e980",
    85 => x"80225280",
    86 => x"0b86e980",
    87 => x"802386e9",
    88 => x"80802270",
    89 => x"83ffff06",
    90 => x"72882a70",
    91 => x"81065153",
    92 => x"51527080",
    93 => x"2e8f3873",
    94 => x"802e81be",
    95 => x"38718280",
    96 => x"862e80db",
    97 => x"38910b86",
    98 => x"e9808423",
    99 => x"84808082",
   100 => x"b5047488",
   101 => x"2b848080",
   102 => x"87840c81",
   103 => x"13830684",
   104 => x"80808784",
   105 => x"0870982c",
   106 => x"53565384",
   107 => x"808082a0",
   108 => x"04848080",
   109 => x"87840888",
   110 => x"2b848080",
   111 => x"87840c81",
   112 => x"12830684",
   113 => x"80808784",
   114 => x"0870982c",
   115 => x"53565380",
   116 => x"0b848080",
   117 => x"87800853",
   118 => x"54848080",
   119 => x"81f00480",
   120 => x"54fed5ca",
   121 => x"0b86e980",
   122 => x"802386e9",
   123 => x"80802251",
   124 => x"810b86e9",
   125 => x"80802386",
   126 => x"e9808022",
   127 => x"517386e9",
   128 => x"80802386",
   129 => x"e9808022",
   130 => x"517786e9",
   131 => x"80802386",
   132 => x"e9808022",
   133 => x"517386e9",
   134 => x"80802386",
   135 => x"e9808022",
   136 => x"517386e9",
   137 => x"80802386",
   138 => x"e9808022",
   139 => x"51910b86",
   140 => x"e9808423",
   141 => x"84808082",
   142 => x"b5047682",
   143 => x"80800751",
   144 => x"70722e09",
   145 => x"8106febd",
   146 => x"38791057",
   147 => x"78802e81",
   148 => x"f0387874",
   149 => x"84808087",
   150 => x"880c5684",
   151 => x"80808788",
   152 => x"08527181",
   153 => x"b5387584",
   154 => x"17710884",
   155 => x"80808784",
   156 => x"0c811483",
   157 => x"06848080",
   158 => x"87880c84",
   159 => x"80808784",
   160 => x"0870982c",
   161 => x"ff1b5455",
   162 => x"56575372",
   163 => x"ff2e80cb",
   164 => x"387186e9",
   165 => x"80803486",
   166 => x"e9808033",
   167 => x"5171802e",
   168 => x"ae388480",
   169 => x"80878808",
   170 => x"527180ca",
   171 => x"38758417",
   172 => x"71088480",
   173 => x"8087840c",
   174 => x"81148306",
   175 => x"84808087",
   176 => x"880c8480",
   177 => x"80878408",
   178 => x"70982c55",
   179 => x"525754ff",
   180 => x"135372ff",
   181 => x"2e098106",
   182 => x"ffb73875",
   183 => x"84808087",
   184 => x"800c910b",
   185 => x"86e98084",
   186 => x"23810b84",
   187 => x"808086f0",
   188 => x"0c02a805",
   189 => x"0d047388",
   190 => x"2b848080",
   191 => x"87840c81",
   192 => x"12830684",
   193 => x"80808788",
   194 => x"0c848080",
   195 => x"87840870",
   196 => x"982c5354",
   197 => x"84808085",
   198 => x"cf047488",
   199 => x"2b848080",
   200 => x"87840c81",
   201 => x"12830684",
   202 => x"80808788",
   203 => x"0c848080",
   204 => x"87840870",
   205 => x"982cff19",
   206 => x"55535484",
   207 => x"8080858b",
   208 => x"04728480",
   209 => x"8087880c",
   210 => x"84808084",
   211 => x"db040000",
   212 => x"00ffffff",
   213 => x"ff00ffff",
   214 => x"ffff00ff",
   215 => x"ffffff00",
   216 => x"48656c6c",
   217 => x"6f2c2077",
   218 => x"6f726c64",
   219 => x"210a0064",
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

