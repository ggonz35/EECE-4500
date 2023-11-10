library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.ads_complex_pkg.all;
use work.vga_data.all;

entity mandelbrot is
    generic( iterations: positive := 16 );
end entity mandelbrot;

architecture steve of mandelbrot is

    constant PATH: string := "C:\\Users\\Zeph\\Desktop\\steve_one.bmp";

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

    function compute_point(c: in ads_complex; iterations: in positive) return natural is
        variable z: ads_complex := complex_zero;
        variable iteration: natural := 0;
        constant threshold: ads_sfixed := to_ads_sfixed(4.0); -- You can adjust the threshold
    begin
        while iteration < iterations loop
            z := ads_square(z) + c;
            if abs2(z) > threshold then
                return iteration;
            end if;
            iteration := iteration + 1;
        end loop;
        return 0;
    end function compute_point;

begin

    generate_set();

end architecture steve;