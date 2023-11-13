library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.ads_fixed.all;
use work.ads_complex_pkg.all;
use work.vga_data.all;

entity toplevel is
    generic( iterations: positive := 16 );
end entity toplevel;

architecture steve of toplevel is

    constant PATH: string := "/home/user/Desktop/toplevel/steve_one.bmp";

    -- four bit color value
    type color_value is array (0 to 3) of std_logic;
    type vga_color

    -- one of the rgb values
    variable : color_value(3 downto 0) := ("");

    -- Values for rgb
    variable rgb_array: color(2 downto 0) := ("111100000000", "000011110000", "000000001111");
    
    -- Color map of 4 colors
    variable vga_color_map: vga_color(3 downto 0) := (rgb_array, rgb_array, rgb_array, rgb_array);

    function compute_point(c: in ads_complex) return natural is
        variable z: ads_complex := ads_cmplx(to_ads_sfixed(0), to_ads_sfixed(0));
        variable iteration: natural := 0;
        constant threshold: ads_sfixed := to_ads_sfixed(64);
    begin
        while iteration < iterations loop
            z := z*z + c;
            if abs2(z) > threshold then
                return iteration;
            end if;
            iteration := iteration + 1;
        end loop;
        return 0;
    end function compute_point;

    procedure generate_set is

        variable c: ads_complex;
        variable color_index: natural;
        variable color: std_logic_vector(3 downto 0);
        --file output_file: text open write_mode is PATH;
        file output_file: text open write_mode is PATH;
        variable output_line: line;

    begin

        for l in 0 to 479 loop
            for p in 0 to 639 loop

                if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then

                    c := ads_cmplx(to_ads_sfixed(3.2 * real(p) / 640.0 - 2.2), to_ads_sfixed(2.2 * real(240 - l) / 480.0));
                    color_index := compute_point(c);
                    color := vga_color_map(color_index);
                    write(output_file, natural'image(color) & LF);
                    
                end if;
            end loop;
        end loop;
        file_close(output_file);
    end procedure;

begin
    generate_set;
end architecture steve;
