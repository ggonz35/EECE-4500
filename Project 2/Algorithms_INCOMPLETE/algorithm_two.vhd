library ieee;
use ieee.std_logic_1164.all;

use work.ads_complex_pkg.all;
use work.vga_data.all;
use work.ads_fixed.all;

entity generate_set is
end generate_set;


architecture set_gen of generate_set is
	-- signal decleration
	     signal c: ads_complex;
        signal color_index: natural;
        signal color: std_logic_vector(3 downto 0);
		  signal l: natural;
		  signal p: natural;
	
	begin

	generate_set:process(c, color_index, color, p)

    begin

        for l in 0 to 479 loop
            for p in 0 to 639 loop

                if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then
                    c <= ads_cmplx(to_ads_sfixed(3.2 * real(p) / 640.0 - 2.2), to_ads_sfixed(2.2 * real(240 - l) / 480.0));
                    color_index <= compute_point(c, iterations);
                    color <= vga_color_map(color_index);
                    
                end if;
            end loop;
        end loop;
    end process;
end set_gen;


