library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

use work.ads.all;
use work.vga.all;

entity mandelbrot is
	port(
		clk_50 			: in std_logic;
		vga_vs 			: out std_logic;			
		vga_hs 			: out std_logic;
		vga_r 			: out std_logic(0 to 3);
		vga_g 			: out std_logic(0 to 3);
		vga_b 			: out std_logic(0 to 3)
		
	);
end mandelbrot;

architecture steve of mandelbrot is
	
	signal vga_clk		: std_logic_vector (4 downto 0);
	signal rst			: std_logic;
	signal point_out	: coordinate;
	signal p_val_out	: boolean;
	signal vs_out 		: std_logic;
	signal hs_out 		: std_logic;
	signal r_out		: std_logic_vector(0 to 3);
	signal g_out		: std_logic_vector(0 to 3);
	signal b_out		: std_logic_vector(0 to 3);
	signal a_set		: std_logic := '0';
	signal l_set		: std_logic;

begin
    -- Add your VGA configuration and color map setup here
	 
	pll :entity vga_pll 
	
		port map (
		--in
		arset				<= a_set,
		in_clk			<= clk_50,
		
		--out
		vga_clk 			<= c0,
		l_set 			<= locked
		
	);
	
	
	vga:entity vga_fsm
	
		  port map(
		  --in
		  vga_clock		<= vga_clk,
        reset			<= rst,

		  --out
		  point_out		<=	point,
		  p_val_out		<= point_valid,

		  vs_out			<= h_sync,
		  hs_out			<= v_sync
		
	);
	
	c_gen: entity generate_set
			port map(
			--in
				input_cord <= point_out,
				
			--out
				c_g_out		<=c_out
			);
	
	s_reg:entity shit_reg
	
		port map(
		--in
		clock				<=vga_clk,
		shiftin			<= ,
		
		--out
		s_r_out			<=shiftout,
		no_ide			<=taps
	);
	
	ppln:entity pipeline
		
		port map	(
			--in
		  clock			<=vga_clock,
        reset			<=rst,
        c				<= ,
        z				<= ,
		  
			--out
        ppln_out		<= ov_out
		
	);
	
	
	 

end architecture steve;
