library ieee;
use ieee.std_logic_1164.all;

use work.ads_complex_pkg.all;
use work.vga_data.all;
use work.ads_fixed.all;

entity generate_set is
	port(
		input_cord: coordinate;
	);
	generic(
		x_visible: natural;
		y_visible: natural
	);
end generate_set;


architecture set_gen of generate_set is
	-- signal decleration
	    signal c: ads_complex;
		signal z: ads_complex;
        signal color_index: natural;
        signal color: std_logic_vector(3 downto 0);
		signal l: natural;
		signal p: natural;

		-- This should probably go into a seperate package but is used to make the color map
		type color_value is array (0 to 3) of std_logic;
    	type color_value_array is array (0 to 2) of std_logic_vector (0 to 3);
    	type color_map is array (natural range <>) of color_value_array;

		-- This is the vga color map
		variable vga_color_map: color_map(0 to 3) := 
        (
        ("0000", "0010", "1011"), -- blue
        ("0011", "0110", "1111"), -- pink
        ("0011", "0111", "1000"), -- purple
        ("0000", "0000", "0000")
        );

		-- We need to declare the pipeline here, the output of the pipeline is the color index
		component pipeline is
			port (
				clock:  in  std_logic;
				reset:  in  std_logic;
				c:      in  ads_complex;
				z:      in  ads_complex;

				ov_out: out natural
			);
		end component pipeline;
	
	begin

	generate_set:process(c, color_index, color, p)

		-- Initiate the actual entity
		PIPE : pipeline port map (
			clock => clock;
			reset => reset;
			c => c,
			z => z,
			ov_out => color_index
		);
	
		x_visible <= input_cord.x;
		y_visible <= input_cord.y;

		begin

			for l in 0 to 479 loop
				for p in 0 to 639 loop

					if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then
						c <= ads_cmplx(to_ads_sfixed(3.2 * real(p) / 640.0 - 2.2), to_ads_sfixed(2.2 * real(240 - l) / 480.0));
						
						-- Using the mod operator to index into the array but this may not be super efficient
						color <= vga_color_map(color_index mod 4);

						-- TODO: make this function output to screen
						
					end if;
				end loop;
			end loop;
    end process;
end set_gen;
