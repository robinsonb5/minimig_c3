library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

library altera;
use altera.altera_syn_attributes.all;


entity C3BoardToplevel is
port(
		clk_50 	: in 	std_logic;
		reset_n : in 	std_logic;
		led_out : out 	std_logic;

		-- SDRAM - chip 1
		sd1_addr : out std_logic_vector(11 downto 0);
		sd1_data : inout std_logic_vector(7 downto 0);
		sd1_ba : out std_logic_vector(1 downto 0);
		sd1_clk : out std_logic;
		sd1_cke : out std_logic;
		sd1_dqm : out std_logic;
		sd1_cs : out std_logic;
		sd1_we : out std_logic;
		sd1_cas : out std_logic;
		sd1_ras : out std_logic;

		-- SDRAM - chip 2
		sd2_addr : out std_logic_vector(11 downto 0);
		sd2_data : inout std_logic_vector(7 downto 0);
		sd2_ba : out std_logic_vector(1 downto 0);
		sd2_clk : out std_logic;
		sd2_cke : out std_logic;
		sd2_dqm : out std_logic;
		sd2_cs : out std_logic;
		sd2_we : out std_logic;
		sd2_cas : out std_logic;
		sd2_ras : out std_logic;
		
		-- VGA
		vga_red 		: out unsigned(5 downto 0);
		vga_green 	: out unsigned(5 downto 0);
		vga_blue 	: out unsigned(5 downto 0);
		
		vga_hsync 	: buffer std_logic;
		vga_vsync 	: buffer std_logic;

		-- PS/2
		ps2k_clk : inout std_logic;
		ps2k_dat : inout std_logic;
		ps2m_clk : inout std_logic;
		ps2m_dat : inout std_logic;
		
		-- Audio
		aud_l : out std_logic;
		aud_r : out std_logic;
		
		-- RS232
		rs232_rxd : in std_logic;
		rs232_txd : out std_logic;

		-- SD card interface
		sd_cs : out std_logic;
		sd_miso : in std_logic;
		sd_mosi : out std_logic;
		sd_clk : out std_logic;
		
		-- Power and LEDs
		power_button : in std_logic;
		power_hold : out std_logic := '1';
		leds : out std_logic_vector(3 downto 0);
		
		-- Any remaining IOs yet to be assigned
		misc_ios_1 : out std_logic_vector(5 downto 0);
		misc_ios_21 : out std_logic_vector(13 downto 0);
		misc_ios_22 : out std_logic_vector(9 downto 0);
		misc_ios_3 : out std_logic_vector(1 downto 0)
	);
end entity;

architecture RTL of C3BoardToplevel is
-- Assigns pin location to ports on an entity.
-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute chip_pin : string;

-- Board features

attribute chip_pin of clk_50 : signal is "152";
attribute chip_pin of reset_n : signal is "181";
attribute chip_pin of led_out : signal is "233";

-- SDRAM (2 distinct 8-bit wide chips)

attribute chip_pin of sd1_addr : signal is "83,69,82,81,80,78,99,110,63,64,65,68";
attribute chip_pin of sd1_data : signal is "109,103,111,93,100,106,107,108";
attribute chip_pin of sd1_ba : signal is "70,71";
attribute chip_pin of sd1_clk : signal is "117";
attribute chip_pin of sd1_cke : signal is "84";
attribute chip_pin of sd1_dqm : signal is "87";
attribute chip_pin of sd1_cs : signal is "72";
attribute chip_pin of sd1_we : signal is "88";
attribute chip_pin of sd1_cas : signal is "76";
attribute chip_pin of sd1_ras : signal is "73";

attribute chip_pin of sd2_addr : signal is "142,114,144,139,137,134,148,161,120,119,118,113";
attribute chip_pin of sd2_data : signal is "166,164,162,160,146,147,159,168";
attribute chip_pin of sd2_ba : signal is "126,127";
attribute chip_pin of sd2_clk : signal is "186";
attribute chip_pin of sd2_cke : signal is "143";
attribute chip_pin of sd2_dqm : signal is "145";
attribute chip_pin of sd2_cs : signal is "128";
attribute chip_pin of sd2_we : signal is "133";
attribute chip_pin of sd2_cas : signal is "132";
attribute chip_pin of sd2_ras : signal is "131";

-- Video output via custom board

attribute chip_pin of vga_red : signal is "13, 9, 5, 240, 238, 236";
attribute chip_pin of vga_green : signal is "49, 45, 43, 39, 37, 18";
attribute chip_pin of vga_blue : signal is "52, 50, 46, 44, 41, 38";

attribute chip_pin of vga_hsync : signal is "51";
attribute chip_pin of vga_vsync : signal is "55";

-- Audio output via custom board

attribute chip_pin of aud_l : signal is "6";
attribute chip_pin of aud_r : signal is "22";

-- PS/2 sockets on custom board

attribute chip_pin of ps2k_clk : signal is "235";
attribute chip_pin of ps2k_dat : signal is "237";
attribute chip_pin of ps2m_clk : signal is "239";
attribute chip_pin of ps2m_dat : signal is "4";

-- RS232
attribute chip_pin of rs232_rxd : signal is "98";
attribute chip_pin of rs232_txd : signal is "112";

-- SD card interface
attribute chip_pin of sd_cs : signal is "183";
attribute chip_pin of sd_miso : signal is "194";
attribute chip_pin of sd_mosi : signal is "185";
attribute chip_pin of sd_clk : signal is "188";


-- Power and LEDs
attribute chip_pin of power_hold : signal is "171";
attribute chip_pin of power_button : signal is "94";

attribute chip_pin of leds : signal is "173, 169, 167, 135";

-- Free pins, not yet assigned

attribute chip_pin of misc_ios_1 : signal is "12,14,56,234,21,57";

attribute chip_pin of misc_ios_21 : signal is "184,187,189,195,197,201,203,214,217,219,221,223,226,231";
attribute chip_pin of misc_ios_22 : signal is "176,196,200,202,207,216,218,224,230,232";
attribute chip_pin of misc_ios_3 : signal is "95,177";

-- Signals internal to the project

signal clk : std_logic;
signal reset : std_logic;  -- active low
signal counter : unsigned(34 downto 0);

signal debugvalue : std_logic_vector(15 downto 0);

signal currentX : unsigned(11 downto 0);
signal currentY : unsigned(11 downto 0);
signal end_of_pixel : std_logic;
signal end_of_line : std_logic;
signal end_of_frame : std_logic;

-- SDRAM - merged signals to make the two chips appear as a single 16-bit wide entity.
signal sdr_addr : std_logic_vector(11 downto 0);
signal sdr_dqm : std_logic_vector(1 downto 0);
signal sdr_we : std_logic;
signal sdr_cas : std_logic;
signal sdr_ras : std_logic;
signal sdr_cs : std_logic;
signal sdr_ba : std_logic_vector(1 downto 0);
-- signal sdr_clk : std_logic;
signal sdr_cke : std_logic;

signal ps2m_clk_in : std_logic;
signal ps2m_clk_out : std_logic;
signal ps2m_dat_in : std_logic;
signal ps2m_dat_out : std_logic;

signal ps2k_clk_in : std_logic;
signal ps2k_clk_out : std_logic;
signal ps2k_dat_in : std_logic;
signal ps2k_dat_out : std_logic;

signal power_led : unsigned(5 downto 0);
signal disk_led : unsigned(5 downto 0);
signal net_led : unsigned(5 downto 0);
signal odd_led : unsigned(5 downto 0);

signal vga_r : std_logic_vector(7 downto 0);
signal vga_g : std_logic_vector(7 downto 0);
signal vga_b : std_logic_vector(7 downto 0);

-- Minimig signals

		-- CPU
signal cpu_address : std_logic_vector(31 downto 0);
signal cpu_data_in : std_logic_vector(15 downto 0);
signal cpu_data_out : std_logic_vector(15 downto 0);
signal cpu_data_from_ram : std_logic_vector(15 downto 0);
signal n_cpu_ipl : std_logic_vector(2 downto 0);
signal n_cpu_as : std_logic;
signal n_cpu_uds : std_logic;
signal n_cpu_lds : std_logic;
signal cpu_r_w : std_logic;
signal n_cpu_dtack : std_logic;
signal n_cpu_reset : std_logic;

		-- SDRAM
		
signal mm_ram_data_out : std_logic_vector(15 downto 0);
signal mm_ram_data_in : std_logic_vector(15 downto 0);
signal mm_ram_address : std_logic_vector(21 downto 1);
signal mm_ram_bhe : std_logic;
signal mm_ram_ble : std_logic;
signal mm_ram_we : std_logic;
signal mm_ram_oe : std_logic;
		
		-- Clocks
		
signal clk7m : std_logic;
signal clk28m : std_logic;
signal pll_locked : std_logic;
		
		-- Peripherals

signal spi_chipselect : std_logic_vector(7 downto 0);	
signal spi_sdi : std_logic;
signal spi_sdo : std_logic;
signal spi_sck : std_logic;
		
		-- Config

signal cpu_config : std_logic_vector(1 downto 0);
signal mem_config : std_logic_vector(5 downto 0);
signal sdram_ready : std_logic;
signal cpu_ena : std_logic;

		-- TG68 signals
signal wrd : std_logic;
signal ena7RDreg : std_logic;
signal ena7WRreg : std_logic;
signal enaWRreg : std_logic;
signal enaRDreg : std_logic;
        
signal cpu_ramaddr : std_logic_vector(31 downto 0);
signal cpustate : std_logic_vector(5 downto 0);

signal maincpuready : std_logic;
signal cpu_dma : std_logic;
signal cpu_ram_lds : std_logic;
signal cpu_ram_uds : std_logic;

-- OSD CPU signals

signal hostWR : std_logic_vector(15 downto 0);
signal hostAddr : std_logic_vector(23 downto 0);
signal hostState : std_logic_vector(2 downto 0);
signal hostL : std_logic;
signal hostU : std_logic;
signal hostRD : std_logic_vector(15 downto 0);
signal hostena	: std_logic;
signal hostena_in	: std_logic;
signal hostdata : std_logic_vector(15 downto 0);


COMPONENT Minimig1
	GENERIC ( NTSC : integer := 0 );
	PORT
	(
		cpu_address		:	 IN STD_LOGIC_VECTOR(23 DOWNTO 1);
		cpu_data		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		cpu_wrdata		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		n_cpu_ipl		:	 OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		n_cpu_as		:	 IN STD_LOGIC;
		n_cpu_uds		:	 IN STD_LOGIC;
		n_cpu_lds		:	 IN STD_LOGIC;
		cpu_r_w		:	 IN STD_LOGIC;
		n_cpu_dtack		:	 OUT STD_LOGIC;
		n_cpu_reset		:	 OUT STD_LOGIC;
		ram_data		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		ram_address		:	 OUT STD_LOGIC_VECTOR(21 DOWNTO 1);
		n_ram_ce		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		n_ram_bhe		:	 OUT STD_LOGIC;
		n_ram_ble		:	 OUT STD_LOGIC;
		n_ram_we		:	 OUT STD_LOGIC;
		n_ram_oe		:	 OUT STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		clk28m		:	 IN STD_LOGIC;
		rxd		:	 IN STD_LOGIC;
		txd		:	 OUT STD_LOGIC;
		cts		:	 IN STD_LOGIC;
		rts		:	 OUT STD_LOGIC;
		n_joy1		:	 IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		n_joy2		:	 IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		n_15khz		:	 IN STD_LOGIC;
		pwrled		:	 OUT STD_LOGIC;
		kbddat		:	 IN STD_LOGIC;
		kbdclk		:	 IN STD_LOGIC;
		msdat		:	 IN STD_LOGIC;
		msclk		:	 IN STD_LOGIC;
		msdato		:	 OUT STD_LOGIC;
		msclko		:	 OUT STD_LOGIC;
		kbddato		:	 OUT STD_LOGIC;
		kbdclko		:	 OUT STD_LOGIC;
		n_scs		:	 IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		direct_sdi		:	 IN STD_LOGIC;
		sdi		:	 IN STD_LOGIC;
		sdo		:	 INOUT STD_LOGIC;
		sck		:	 IN STD_LOGIC;
		n_hsync		:	 OUT STD_LOGIC;
		n_vsync		:	 OUT STD_LOGIC;
		red		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		green		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		blue		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		aud_l		:	 OUT STD_LOGIC;
		aud_r		:	 OUT STD_LOGIC;
		cpu_config		:	 OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		memcfg		:	 OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		drv_snd		:	 OUT STD_LOGIC;
		floppyled		:	 OUT STD_LOGIC;
		init_b		:	 OUT STD_LOGIC;
		ramdata_in		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		cpurst		:	 IN STD_LOGIC;
		locked		:	 IN STD_LOGIC;
		sysclock		:	 IN STD_LOGIC;
		ascancode		:	 IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		n_joy3		:	 IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		n_joy4		:	 IN STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;


begin
	vga_red<=unsigned(vga_r(7 downto 2));
	vga_green<=unsigned(vga_g(7 downto 2));
	vga_blue<=unsigned(vga_b(7 downto 2));

	ps2m_dat_in<=ps2m_dat;
	ps2m_dat <= '0' when ps2m_dat_out='0' else 'Z';
	ps2m_clk_in<=ps2m_clk;
	ps2m_clk <= '0' when ps2m_clk_out='0' else 'Z';

	ps2k_dat_in<=ps2k_dat;
	ps2k_dat <= '0' when ps2k_dat_out='0' else 'Z';
	ps2k_clk_in<=ps2k_clk;
	ps2k_clk <= '0' when ps2k_clk_out='0' else 'Z';

	sdr_cke<='1';
	
	sd1_addr <= sdr_addr;
	sd1_dqm <= sdr_dqm(0);
--	sd1_clk <= sdr_clk;
	sd1_we <= sdr_we;
	sd1_cas <= sdr_cas;
	sd1_ras <= sdr_ras;
	sd1_cs <= sdr_cs;
	sd1_ba <= sdr_ba;
	sd1_cke <= sdr_cke;

	sd2_addr <= sdr_addr;
	sd2_dqm <= sdr_dqm(1);
--	sd2_clk <= sdr_clk;
	sd2_we <= sdr_we;
	sd2_cas <= sdr_cas;
	sd2_ras <= sdr_ras;
	sd2_cs <= sdr_cs;
	sd2_ba <= sdr_ba;
	sd2_cke <= sdr_cke;
	
	sd_clk <= spi_sck;
	sd_cs <= spi_chipselect(1);
	sd_mosi <= spi_sdi;

	mypll : entity work.PLL
		port map (
			inclk0 => clk_50,
			c0 => clk,
			c1 => sd1_clk,
			c2 => open,
			c3 => clk28m,
			c4 => clk7m,
			locked => pll_locked
		);

	mypll2 : entity work.PLL
		port map (
			inclk0 => clk_50,
			c0 => open,
			c1 => sd2_clk,
			c2 => open,
			c3 => open,
			c4 => open,
			locked => open
		);

	myleds : entity work.statusleds_pwm
	port map(
		clk => clk,
		power_led => power_led,
		disk_led => disk_led,
		net_led => net_led,
		odd_led => odd_led,
		leds_out => leds
	);
	
	myreset : entity work.poweronreset
		port map(
			clk => clk,
			reset_button => reset_n,
			reset_out => reset,
			power_button => power_button,
			power_hold => power_hold		
		);
		
MyMinimig: COMPONENT Minimig1
	generic map
	(
		NTSC => 0
	)
	port map
	(
		-- CPU signals
		cpu_address => cpu_address(23 downto 1),
		cpu_data	=> cpu_data_in,
		cpu_wrdata => cpu_data_out,
		n_cpu_ipl => n_cpu_ipl,
		n_cpu_as => n_cpu_as,
		n_cpu_uds => n_cpu_uds,
		n_cpu_lds	=> n_cpu_lds,
		cpu_r_w => cpu_r_w,
		n_cpu_dtack => n_cpu_dtack,
		n_cpu_reset => n_cpu_reset,
		
		-- SDRAM
		
		ram_data	=> mm_ram_data_out,
		ram_address => mm_ram_address,
		n_ram_ce	=> open, -- mm_ram_ce,
		n_ram_bhe => mm_ram_bhe,
		n_ram_ble	=> mm_ram_ble,
		n_ram_we => mm_ram_we,
		n_ram_oe => mm_ram_oe,
		
		-- Clocks
		
		clk => clk7m, -- 113Mhz
		clk28m => clk28m, -- 28Mhz
		
		-- Peripherals
		
--		rxd => rs232_rxd,
--		txd => rs232_txd,
		rxd => '1',
		txd => open,
		cts => '0',
		rts => open,
		n_joy1	=> "111111",
		n_joy2 => "111111",
		n_15khz => '1',
		pwrled => power_led(5),
		kbddat => ps2k_dat_in,
		kbdclk => ps2k_clk_in,
		msdat => ps2m_dat_in,
		msclk => ps2m_clk_in,
		msdato => ps2m_dat_out,
		msclko => ps2m_clk_out,
		kbddato => ps2k_dat_out,
		kbdclko => ps2k_clk_out,
		n_scs => spi_chipselect(6 downto 4),
		direct_sdi => sd_miso,
		sdi => spi_sdi,
		sdo => spi_sdo,
		sck => spi_sck,
		
		-- Video
		
		n_hsync => vga_hsync,
		n_vsync => vga_vsync,
		red => vga_r(7 downto 4),
		green => vga_g(7 downto 4),
		blue => vga_b(7 downto 4),
		
		aud_l => aud_l,
		aud_r => aud_r,
		cpu_config => cpu_config,
		memcfg => mem_config,
		drv_snd => open,
		floppyled => disk_led(5),
		init_b => open,
		ramdata_in => mm_ram_data_in,
		cpurst => not (maincpuready and n_cpu_reset and sdram_ready),
		locked => sdram_ready,
		sysclock => clk,
		ascancode => "100000000",
		n_joy3 => "111111",
		n_joy4	=> "111111"
	);
		
MainCPU: entity work.TG68K
   port map
	(        
		clk => clk,
		reset => n_cpu_reset and sdram_ready,
		clkena_in => '1',
		  
	  -- Standard MC68000 signals...
		  
		IPL => n_cpu_ipl,
		dtack => n_cpu_dtack,

		vpa => '1',
		ein => '1',
		
		addr => cpu_address,
		data_read => cpu_data_in,
		data_write => cpu_data_out,
		as => n_cpu_as,
		uds => n_cpu_uds,
		lds => n_cpu_lds,
		rw => cpu_r_w,
		e => open,
		vma => open,

		  -- TG68 specific signals...
		  
      wrd => wrd,
      ena7RDreg => ena7RDreg,
      ena7WRreg => ena7WRreg,
      enaWRreg => enaWRreg,
       
      fromram => cpu_data_from_ram,
      ramready => cpu_ena,	-- dtack equivalent for fastram access 
      cpu => cpu_config,
      memcfg => mem_config,
      ramaddr => cpu_ramaddr,
      cpustate => cpustate,

		nResetOut => maincpuready,
      skipFetch => open,
      cpuDMA => cpu_dma,
      ramlds => cpu_ram_lds,
      ramuds => cpu_ram_uds
	);

mysdram : entity work.sdram
	port map
	(
		sdata(15 downto 8) => sd2_data,
		sdata(7 downto 0) => sd1_data,
		sdaddr(11 downto 0) => sdr_addr,
		dqm => sdr_dqm,
		sd_cs(0)	=> sdr_cs,
		sd_cs(3 downto 1) => open,
		ba => sdr_ba,
		sd_we => sdr_we,
		sd_ras => sdr_ras,
		sd_cas => sdr_cas,

		sysclk => clk,
		reset_in	=> pll_locked and reset,
	
		hostWR => hostWR,
		hostAddr	=> hostAddr,
		hostState => hostState,
		hostL => hostL,
		hostU => hostU,
		hostRD => hostRD,
		hostena => hostena_in,

		cpuWR	=> cpu_data_out,
		cpuAddr => cpu_ramaddr(24 downto 1),
		cpuU => cpu_ram_uds,
		cpuL => cpu_ram_lds,
		cpustate	=> cpustate,
		cpu_dma => cpu_dma,
		cpuRD	=> cpu_data_from_ram,
		cpuena => cpu_ena,
		
		chipWR => mm_ram_data_out,
		chipAddr => "00"&mm_ram_address,
		chipU => mm_ram_bhe,
		chipL	=> mm_ram_ble,
		chipRW => mm_ram_we,
		chip_dma	=> mm_ram_oe,
		chipRD => mm_ram_data_in,

		c_7m => clk7m,

		reset_out => sdram_ready,
		enaRDreg => open,
		enaWRreg	=> enaWRreg,
		ena7RDreg => ena7RDreg,
		ena7WRreg => ena7WRreg
	);
	
mycfide : entity work.cfide 
   port map ( 
		sysclk => clk,
		n_reset => sdram_ready,
		cpuena_in => hostena_in,
		memdata_in => hostRD,
		addr => hostaddr,
		cpudata_in => hostWR,
		state => hostState(1 downto 0),
		lds => hostL,
		uds => hostU,
		sd_di => spi_sdo,
		
		memce => hostState(2),
		cpudata => hostdata,
		cpuena => hostena,	-- And with enaWRreg as host clkena_in
		sd_cs => spi_chipselect,
		sd_clk => spi_sck,
		sd_do => spi_sdi,
		sd_dimm => sd_miso,
		enaWRreg => enaWRreg,
		debugTxD => rs232_txd,
		debugRxD => rs232_rxd
   );

myhostcpu : entity work.TG68KdotC_Kernel
   port map(clk => clk,
		nReset => sdram_ready,
		clkena_in => hostena and enaWRreg,
		data_in => hostdata,
		addr(23 downto 0) => hostaddr,
		addr(31 downto 24) => open,
		data_write => hostWR,
		nWr => open, -- uses busstate instead?
		nUDS => hostU,
		nLDS => hostL,
		busstate	=> hostState(1 downto 0),
		nResetOut => open,
		FC => open,
-- for debug		
		skipFetch => open,
		regin => open
	);
	
end rtl;
