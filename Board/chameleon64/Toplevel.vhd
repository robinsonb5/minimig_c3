library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity Fampiga_top is
  port
    (
-- Clocks
		clk8 : in std_logic;
		phi2_n : in std_logic;
		dotclock_n : in std_logic;

-- Bus
		romlh_n : in std_logic;
		ioef_n : in std_logic;

-- Buttons
		freeze_n : in std_logic;

-- MMC/SPI
		spi_miso : in std_logic;
		mmc_cd_n : in std_logic;
		mmc_wp : in std_logic;

-- MUX CPLD
		mux_clk : out std_logic;
		mux : out unsigned(3 downto 0);
		mux_d : out unsigned(3 downto 0);
		mux_q : in unsigned(3 downto 0);

-- USART
		usart_tx : in std_logic;
		usart_clk : in std_logic;
		usart_rts : in std_logic;
		usart_cts : in std_logic;

-- SDRam
		sd_clk : out std_logic;
		sd_data : inout std_logic_vector(15 downto 0);
		sd_addr : out std_logic_vector(12 downto 0);
		sd_we_n : out std_logic;
		sd_ras_n : out std_logic;
		sd_cas_n : out std_logic;
		sd_ba_0 : out std_logic;
		sd_ba_1 : out std_logic;
		sd_ldqm : out std_logic;
		sd_udqm : out std_logic;

-- Video
		red : out std_logic_vector(4 downto 0);
		grn : out std_logic_vector(4 downto 0);
		blu : out std_logic_vector(4 downto 0);
		nHSync : out std_logic;
		nVSync : out std_logic;

-- Audio
		sigmaL : out std_logic;
		sigmaR : out std_logic
	);
  
end Fampiga_top;

architecture RTL of Fampiga_top is

  signal reset_n 	: std_logic := '1';  
  signal clk : std_logic;
  signal clk7m : std_logic;
  signal clk28m : std_logic;
  signal pll_locked : std_logic;
  
-- Chameleon signals

	signal ena_1mhz : std_logic;
	signal ena_1khz : std_logic;
	
-- System state
	signal no_clock : std_logic;
	signal docking_station : std_logic;
	signal reset : std_logic;
	signal button_reset_n : std_logic;

-- LEDs
	signal led_green : std_logic := '0';
	signal led_red : std_logic := '0';
	signal ir : std_logic;

	signal joystick1 : unsigned(5 downto 0);
	signal joystick2 : unsigned(5 downto 0);
	signal joystick3 : unsigned(5 downto 0);
	signal joystick4 : unsigned(5 downto 0);
	
	signal ir_joya : unsigned(5 downto 0);
	signal ir_joyb : unsigned(5 downto 0);

-- C64 keyboard
	signal keys : unsigned(63 downto 0);
	signal restore_key_n : std_logic;
	signal c64_nmi_n : std_logic; -- Replaces restore_key_n in C64 mode.

-- PS/2 Keyboard
	signal ps2_keyboard_clk_in : std_logic;
	signal ps2_keyboard_dat_in : std_logic;
	signal ps2_keyboard_clk_out : std_logic;
	signal ps2_keyboard_dat_out : std_logic;

-- PS/2 Mouse
	signal ps2_mouse_clk_in: std_logic;
	signal ps2_mouse_dat_in: std_logic;
	signal ps2_mouse_clk_out: std_logic;
	signal ps2_mouse_dat_out: std_logic;
	
-- SD card
	signal spi_cs : std_logic;
	signal spi_mosi : std_logic;
	signal spi_clk : std_logic;
	signal spi_ack : std_logic;
	
	signal joya : std_logic_vector(6 downto 0);
	signal joyb : std_logic_vector(6 downto 0);
	signal joyc : std_logic_vector(6 downto 0);
	signal joyd : std_logic_vector(6 downto 0);

-- Dummy signals for SDRAM
	signal sd_cs : std_logic;
	signal sd_cke : std_logic;
	
	signal debug_rxd : std_logic;
	signal debug_txd : std_logic;
	
--//********************

	signal reset_counter : unsigned(15 downto 0):=X"0000";

begin


process(clk)
begin
	if rising_edge(clk) then
		if reset_counter=X"FFFF" then
			reset_n<='1';
		else
			reset_counter<=reset_counter+1;
			reset_n<='0';
		end if;
	end if;
	reset<=not reset_n;
end process;

	mypll : entity work.PLL
		port map (
			inclk0 => clk8,
			c0 => clk,
			c1 => sd_clk,
			c3 => clk28m,
			c4 => clk7m,
			locked => pll_locked
		);


myFampiga: entity work.Fampiga
	generic map(
		sdram_rows => 13,
		sdram_cols => 9
	)
	port map(
		clk=>clk,
		clk7m=>clk7m,
		clk28m=>clk28m,
		reset_n=>reset_n and button_reset_n,
		powerled_out(1)=>led_red,
		powerled_out(0)=>open, -- FIXME - PWM
		diskled_out=>open, -- FIXME - HDD LED
		oddled_out=>led_green,

		-- SDRAM.  A separate shifted clock is provided by the toplevel
		sdr_addr => sd_addr,
		sdr_data => sd_data,
		sdr_ba(1) => sd_ba_1,
		sdr_ba(0) => sd_ba_0,
		sdr_cke => sd_cke,
		sdr_dqm(1) => sd_udqm,
		sdr_dqm(0) => sd_ldqm,
		sdr_cs => sd_cs,
		sdr_we => sd_we_n,
		sdr_cas => sd_cas_n,
		sdr_ras => sd_ras_n,
	
		-- VGA
		vga_r(7 downto 3) => red,
		vga_g(7 downto 3) => grn,
		vga_b(7 downto 3) => blu,

		vga_hsync => nHSync,
		vga_vsync => nVSync,

		vga_scandbl => '1',
		
		-- PS/2
		ps2k_clk_in => ps2_keyboard_clk_in,
		ps2k_clk_out => ps2_keyboard_clk_out,
		ps2k_dat_in => ps2_keyboard_dat_in,
		ps2k_dat_out => ps2_keyboard_dat_out,
		ps2m_clk_in => ps2_mouse_clk_in,
		ps2m_clk_out => ps2_mouse_clk_out,
		ps2m_dat_in => ps2_mouse_dat_in,
		ps2m_dat_out => ps2_mouse_dat_out,
		
		-- Audio
		aud_l => sigmaL,
		aud_r => sigmaR,
		
		-- RS232
		rs232_rxd => '1',
		rs232_txd => open,
		debug_rxd => debug_rxd,
		debug_txd => debug_txd,

		-- SD card interface
		sd_cs => spi_cs,
		sd_miso => spi_miso,
		sd_mosi => spi_mosi,
		sd_clk => spi_clk,
		sd_ack => spi_ack,

		-- Joystick
		joy1_n => joya,
		joy2_n => joyb,
		joy3_n => (others=>'1'),
		joy4_n => (others=>'1')
	);

	-- Combine joystick signals from io entity and IR port.
	joya <= '1' & std_logic_vector(ir_joya and joystick1);
	joyb <= '1' & std_logic_vector(ir_joyb and joystick2);


-- // Need Clock 50Mhz to Clock 27Mhz

	my1Mhz : entity work.chameleon_1mhz
		generic map (
			clk_ticks_per_usec => 113
		)
		port map (
			clk => clk,
			ena_1mhz => ena_1mhz,
			ena_1mhz_2 => open
		);

	my1Khz : entity work.chameleon_1khz
		port map (
			clk => clk,
			ena_1mhz => ena_1mhz,
			ena_1khz => ena_1khz
		); 


-- -----------------------------------------------------------------------
--
-- The I/O driving entity.
--
-- -----------------------------------------------------------------------
	myIO : entity work.chameleon_io
		generic map (
			enable_docking_station => true,
			enable_c64_joykeyb => true,
			enable_c64_4player => true,
			enable_raw_spi => true,
			enable_iec_access => true
		)
		port map (
		-- Clocks
			clk => clk,
			clk_mux => clk,
			ena_1mhz => ena_1MHz,
			reset => reset, -- reset,
			
			no_clock => no_clock,
			docking_station => docking_station,
			
		-- Chameleon FPGA pins
			-- C64 Clocks
			phi2_n => phi2_n,
			dotclock_n => dotclock_n,
			-- C64 cartridge control lines
			io_ef_n => ioef_n,
			rom_lh_n => romlh_n,

			-- SPI bus
			spi_miso => spi_miso,
			mmc_cs_n => spi_cs,
			spi_raw_clk => spi_clk,
			spi_raw_mosi => spi_mosi,
			spi_raw_ack => spi_ack,

			-- CPLD multiplexer
			mux_clk => mux_clk,
			mux => mux,
			mux_d => mux_d,
			mux_q => mux_q,

		-- LEDs
			led_green => led_green,
			led_red => led_red,
			ir => ir,
		
		-- PS/2 Keyboard
			ps2_keyboard_clk_out => ps2_keyboard_clk_out,
			ps2_keyboard_dat_out => ps2_keyboard_dat_out,
			ps2_keyboard_clk_in => ps2_keyboard_clk_in,
			ps2_keyboard_dat_in => ps2_keyboard_dat_in,
	
		-- PS/2 Mouse
			ps2_mouse_clk_out => ps2_mouse_clk_out,
			ps2_mouse_dat_out => ps2_mouse_dat_out,
			ps2_mouse_clk_in => ps2_mouse_clk_in,
			ps2_mouse_dat_in => ps2_mouse_dat_in,

		-- Buttons
			button_reset_n => button_reset_n,

		-- Joysticks
			joystick1 => joystick1,
			joystick2 => joystick2,
			joystick3 => joystick3,
			joystick4 => joystick4,

		-- Keyboards
			keys => keys,
			restore_key_n => restore_key_n,
			c64_nmi_n => c64_nmi_n,

--			iec_clk_out : in std_logic := '1';
--			iec_dat_out : in std_logic := '1';
			iec_atn_out => debug_txd,
--			iec_srq_out : in std_logic := '1';
			iec_clk_in => debug_rxd
--			iec_dat_in : out std_logic;
--			iec_atn_in : out std_logic;
--			iec_srq_in : out std_logic
			
		);

-- CDTV IR decoder

myIr : entity work.chameleon_cdtv_remote
	port map (
		clk => clk,
		ena_1mhz => ena_1mhz,
		ir => ir,

--		trigger : out std_logic;
--
--		key_1 : out std_logic;
--		key_2 : out std_logic;
--		key_3 : out std_logic;
--		key_4 : out std_logic;
--		key_5 : out std_logic;
--		key_6 : out std_logic;
--		key_7 : out std_logic;
--		key_8 : out std_logic;
--		key_9 : out std_logic;
--		key_0 : out std_logic;
--		key_escape : out std_logic;
--		key_enter : out std_logic;
--		key_genlock : out std_logic;
--		key_cdtv : out std_logic;
--		key_power => ir_coin,
--		key_rew : out std_logic;
--		key_play => ir_start,
--		key_ff : out std_logic;
--		key_stop : out std_logic;
--		key_vol_up : out std_logic;
--		key_vol_dn : out std_logic;
		joystick_a => ir_joya,
		joystick_b => ir_joyb
--		debug_code : out unsigned(11 downto 0)
	);

end RTL;
