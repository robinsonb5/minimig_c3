library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity AutoconfigRAM is
port(
	clk : in std_logic;
	reset_n : in std_logic;
	addr_in : in std_logic_vector(31 downto 0);
	data_in : in std_logic_vector(15 downto 0);
	data_out : out std_logic_vector(3 downto 0);
	config : in std_logic_vector(1 downto 0);
	rw : in std_logic;
	req : in std_logic;
	req_out : out std_logic;
	sel : out std_logic
);
end entity;

-- FIXME - latch config bits on reset.

-- We have two architectures here, one for Zorro II RAM at 0x200000
-- and one for Zorro III RAM at an address specified by the system

architecture ZorroII of AutoconfigRAM is
signal done : std_logic;
signal done_r : std_logic;
signal twomeg : std_logic;
signal fourmeg : std_logic;
signal eightmeg : std_logic;

begin

req_out<=req and done_r;

process(clk)
begin 
	-- Clocked logic to handle the 'done' flag.
	if rising_edge(clk) then
		if reset_n='0' theN
			done<='0';
		else
			if config="00" theN
				done<='1';
			end if;
			
			if req='0' then	-- Avoid propagating the req signal mid-request.
				done_r<=done;
			end if;

			twomeg<=config(0) or config(1);
			fourmeg<=config(1);
			eightmeg<=config(0) and config(1);	

			-- Handle write to config register
			if req='1' and rw='0' then
				if addr_in(7 downto 0)=X"48" then -- base addr, Zorro II, 24-bit
					done<='1';
					-- ignore for ZII RAM, since it can only be 0x200000
				end if;
			end if;			
		end if;
	end if;
	
	-- Combinational logic for the actual autoconfig data.
	-- Zorro II RAM (Up to 8 meg at 0x200000)
	data_out <= "1111";
	IF req='1' and done='0' THEN
		CASE addr_in(6 downto 1) IS
			WHEN "000000" => data_out <= "1110";		--Zorro-II card, add mem, no ROM
			WHEN "000001" => 
				CASE config(1 downto 0) IS 
					WHEN "01" => data_out <= "0110";		--2MB
					WHEN "10" => data_out <= "0111";		--4MB
					WHEN OTHERS => data_out <= "0000";	--8MB
				END CASE;	
			WHEN "001000" => data_out <= "1110";		-- 5017 / 0x1399 - AMR
			WHEN "001001" => data_out <= "1100";		
			WHEN "001010" => data_out <= "0110";		
			WHEN "001011" => data_out <= "0110";		
			WHEN "010011" => data_out <= "1110";		--serial=1
			WHEN OTHERS => null;
		END CASE;	
	END IF;
end process;

	-- Address decoding
	sel <= '1' when done='1' and addr_in(31 downto 24)=X"00" and
		((twomeg&addr_in(23 downto 21))="1001" or -- two meg enabled, addr 0x200000
		(fourmeg&addr_in(23 downto 21))="1010" or -- four meg enabled, addr 0x400000
		(eightmeg&addr_in(23 downto 21))="1011" or -- eight meg enabled, addr 0x600000
		(eightmeg&addr_in(23 downto 21))="1100") else '0'; -- eight meg, addr 0x800000
		
end architecture;


-- Architecture for Zorro III Autoconfig

architecture ZorroIII of AutoconfigRAM is
signal done : std_logic;
signal done_r : std_logic;
signal enabled : std_logic;
signal base_addr :std_logic_vector(7 downto 0);

begin

req_out<=req and done;

process(clk)
begin 

	-- Clocked logic to handle the 'done' flag.
	if rising_edge(clk) then
		if reset_n='0' theN
			done<='0';
			enabled<='0';
			base_addr<=X"EF"; -- Safe default
		else
			if config="00" theN
				done<='1';
			end if;
						
			if req='0' then	-- Avoid propagating the req signal mid-request.
				done_r<=done;
			end if;

			-- Handle write to config register
			if req='1' and rw='0' then
				if addr_in(7 downto 0)=X"44" then -- Base addr, Zorro III, 32-bit
--				elsif addr_in(7 downto 0)=X"44" then -- base addr
					base_addr<=data_in(15 downto 8);
					enabled<='1';
					done<='1';
				end if;
			end if;			
		end if;
	end if;
	
	-- Combinational logic for the actual autoconfig data.
	-- Zorro III RAM (Up to 16 meg, address assigned by ROM)
	data_out <= "1111";
	IF req='1' and done='0' THEN
		CASE addr_in(6 downto 1) IS
			WHEN "000000" => data_out <= "1010";		--Zorro-III card, add mem, no ROM
			WHEN "000001" => data_out <= "0000";		--8MB (extended to 16 in reg 08)
			when "000100" => data_out <= "0000";		--Memory card, not silenceable, Extended size (16 meg), reserved.
			WHEN "001000" => data_out <= "1110";		-- 5017 / 0x1399 - AMR
			WHEN "001001" => data_out <= "1100";		
			WHEN "001010" => data_out <= "0110";		
			WHEN "001011" => data_out <= "0110";		
			WHEN "010011" => data_out <= "1101";		--serial=2
			WHEN OTHERS => null;
		END CASE;	
	END IF;
end process;

		-- Address decoding
	sel <= '1' when done='1' and enabled='1' and addr_in(31 downto 24)=base_addr else '0';

end architecture;


-- Architecture for Turbo Chip RAM

architecture TurboChip of AutoconfigRAM is
signal done : std_logic;

begin

req_out<=req and done;

process(clk)
begin 

	-- Clocked logic to handle the 'done' flag.
	if rising_edge(clk) then
		if reset_n='0' then
			done<='0';
		else
			if config="00" then
				done<='1';
			end if;

			-- Handle access to config registers
			if req='1' then
				done<='1';
			end if;		
		end if;
	end if;

	-- We're not actually doing any autoconfiguring here, we simply implement it
	-- via the Autoconfig mechanism because it's a simple and elegant way to
	-- combine it with Fast RAM logic and ensure that the system doesn't try to 
	-- use it before the Kickstart overlay has been disabled.
	data_out <= "1111";
end process;

		-- Address decoding - match addresses 0x00000000 to 0x001fffff
	sel <= '1' when config(0)='1' and done='1' and addr_in(31 downto 21)=X"00"&"000" else '0';

end architecture;
