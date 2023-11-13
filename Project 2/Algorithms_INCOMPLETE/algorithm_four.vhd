library ieee;
use ieee.std_logic_1164.all;

entity generate_set is
	port();
	
end generate_set;


architecture set_gen of generate_set is
	-- signal decleration
	
	begin

	procedure generate_set is

        variable c: ads_complex;
        variable color_index: natural;
        variable color: std_logic_vector(3 downto 0);
        file output_file: text open write_mode is PATH;
        variable l: line;

    begin

        for l in 0 to 479 loop
            for p in 0 to 639 loop

                if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then
                    c := ads_cmplx(to_ads_sfixed(3.2 * real(p) / 640.0 - 2.2), to_ads_sfixed(2.2 * real(240 - l) / 480.0));
                    color_index := compute_point(c, iterations);
                    color := vga_color_map(color_index);
                    writeline(output_file, color(2) & color(1) & color(0) & "00");
                    
                end if;
            end loop;
        end loop;
        file_close(fileptr);
    end procedure;
end set_gen;