library ieee;
use ieee.std_logic_1164.all;

use work.ads_complex_pkg.all;
use work.vga_data.all;
use work.ads_fixed.all;

entity generate_set is
	port(
		gs_clk:	in	std_logic_vector(4 downto 0)
		input_cord: in coordinate;
		c_out:		out ads_complex;
	);
	generic(
		x_visible: natural;
		y_visable: natural
	);
end generate_set;


architecture set_gen of generate_set is
	-- signal decleration
	     signal c: ads_complex;
        signal color_index: natural;
        signal color: std_logic_vector(3 downto 0);
		  signal l: natural;
		  signal p: natural;
	
	begin


	x_visable <= input_cord.x;
	y_visable <= input_cord.y;


    begin

		if reset = '1' then
				l <= 0;
				p <= 0;
		elsif rising_edge(gs_clk) then
			if p < '639'
				if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then
						c <= ads_cmplx(to_ads_sfixed(3.2 * real(p) / 640.0 - 2.2), to_ads_sfixed(2.2 * real(240 - l) / 480.0));
						
						-- Using the mod operator to index into the array but this may not be super efficient
						color <= vga_color_map(color_index);
						p <= p + 1
				end if;
			else
				if l < 479
					l <= l + 1;
				end if;
			end if;
		end if;
end set_gen;
