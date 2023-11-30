library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;
use vga.de10_vga.all;


library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

entity mandelbrot is
	generic (
		vga_res: vga_timing := vga_res_default;
		threshold: ads_sfixed := to_ads_sfixed(4);
		pipeline_length: positive := 16
	);
	port (
		clock:	in std_logic;
		reset:	in std_logic;
		
		h_sync:	out std_logic;
		v_sync:	out std_logic;
		color:	out de10_color
	);
end entity mandelbrot;

architecture top of mandelbrot is
	component vga_fsm is
		 generic (
			  vga_res:    vga_timing := vga_res_default
		 );
		 port (
			  vga_clock:      in  std_logic;
			  reset:          in  std_logic;

			  point:          out coordinate;
			  point_valid:    out boolean;

			  h_sync:         out std_logic;
			  v_sync:         out std_logic
		 );
	end component vga_fsm;
	
	component pll
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
		);
	end component;

	
	component pipeline is
		generic (
			pipeline_length:    positive := 16;
			threshold:          ads_sfixed := to_ads_sfixed(4)
		);
		port (
			clock:  in  std_logic;
			reset:  in  std_logic;
			c:      in  ads_complex;
			z:      in  ads_complex;

			ov_out: out natural
		);
	end component pipeline;

	type point_valid_sreg_type is array(0 to pipeline_length) of boolean;
	signal point_valid_sreg: point_valid_sreg_type;
	signal h_sync_sreg: std_logic_vector(0 to pipeline_length);
	signal v_sync_sreg: std_logic_vector(0 to pipeline_length);
	
	signal vga_h_sync, vga_v_sync: std_logic;
	signal vga_point_valid: boolean;
	
	signal vga_clock: std_logic;
	signal point_valid: boolean;
	signal point: coordinate;
	
	signal ov_out: natural;
	signal seed: ads_complex;
	
	function gen_complex (
			pt: in coordinate
		) return ads_complex
	is
		constant max_vga_x: natural := vga_res.horizontal.active;
		constant max_vga_y: natural := vga_res.vertical.active;
		-- viewing area
		-- mandelbrot looks good on RE from -2.2 to 1, IM from -1.2 to 1.2
		-- these could be adjusted for a better aspect ratio
		constant min_re: real := -2.9333;
		constant max_re: real := 2.9333;
		constant min_im: real := -2.2;
		constant max_im: real := 2.2;
		
		constant delta_x: ads_sfixed := to_ads_sfixed((max_re - min_re)/real(max_vga_x));
		constant delta_y: ads_sfixed := to_ads_sfixed((min_im - max_im)/real(max_vga_y));
		
		variable ret: ads_complex;
	begin
		ret.re := delta_x * to_ads_sfixed(pt.x) + to_ads_sfixed(min_re);
		ret.im := delta_y * to_ads_sfixed(pt.y) + to_ads_sfixed(max_im);
		
		return ret;
	end function gen_complex;
	
begin

	set_seed: process(vga_clock, reset) is
	begin
		if reset = '0' then
			seed <= complex_zero;
		elsif rising_edge(vga_clock) then
			seed <= gen_complex(point);
		end if;
	end process set_seed;

	p: pipeline
		generic map (
			pipeline_length =>	pipeline_length,
			threshold =>			threshold
		)
		port map (
			clock =>		vga_clock,
			reset =>		reset,
			c =>			ads_cmplx(to_ads_sfixed(-1), to_ads_sfixed(0)),	-- for mandelbrot, set this to seed
			z =>			seed,															-- for mandelbrot, set this to complex_zero
			ov_out =>	ov_out
		);

	pll_inst : pll PORT MAP (
			inclk0	 => clock,
			c0	 => vga_clock
		);


	vga: vga_fsm
		generic map (
			vga_res => vga_res
		)
		port map (
			vga_clock =>	vga_clock,
			reset =>			reset,
			point =>			point,
			point_valid =>	vga_point_valid,
			h_sync =>		vga_h_sync,	-- todo: feed through shift register after adding pipeline!
			v_sync =>		vga_v_sync	-- todo: same as above!
			
		);
	
	sync: process(vga_clock) is
	begin
		if rising_edge(vga_clock) then
			h_sync_sreg <= vga_h_sync & h_sync_sreg(0 to h_sync_sreg'high - 1);
			v_sync_sreg <= vga_v_sync & v_sync_sreg(0 to v_sync_sreg'high - 1);
			point_valid_sreg <= vga_point_valid & point_valid_sreg(0 to point_valid_sreg'high - 1);
		end if;
	end process sync;
	
	point_valid <= point_valid_sreg(point_valid_sreg'high);
	h_sync <= h_sync_sreg(h_sync_sreg'high);
	v_sync <= v_sync_sreg(v_sync_sreg'high);
		
	color <= ( red => ov_out, green => ov_out, blue => ov_out ) when point_valid else color_black;
end architecture top;