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

architecture behavior of toplevel is

    constant PATH: string := "/home/user/Desktop/toplevel/set.bmp";

    -- four bit color value
    type color_value is array (0 to 3) of std_logic;
    type color_value_array is array (0 to 2) of std_logic_vector (0 to 3);
    type color_map is array (natural range <>) of color_value_array;

    -- COPIED FROM https://stackoverflow.com/questions/15406887/vhdl-convert-vector-to-string
    function to_string ( a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
        begin
            for i in a'range loop
                b(stri) := std_logic'image(a((i)))(2);
            stri := stri+1;
            end loop;
        return b;
    end function;

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
        variable color: color_value_array;

        -- variable vga_color_one: color_value := ("0000", "0000", "1111");
        -- variable vga_color_two: color_value := ("0000", "1111", "0000");
        -- variable vga_color_three: color_value := ("1111", "0000", "0000");
        -- variable vga_color_four: color_value := ("0000", "0000", "0000");
    
        variable vga_color_map: color_map(0 to 3) := 
        (
        ("0000", "0010", "1011"), -- blue
        ("0011", "0110", "1111"), -- pink
        ("0011", "0111", "1000"), -- purple
        ("0000", "0000", "0000")
        );
        --file output_file: text open write_mode is PATH;
        file output_file: text open write_mode is PATH;
        variable output_line: line;

    begin

        write(output_file, "P3" & LF);
        write(output_file, "640 480" & LF);

        for l in 0 to 479 loop
            for p in 0 to 639 loop

                if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then

                    c := ads_cmplx(to_ads_sfixed(3.2 * real(p) / 640.0 - 2.2), to_ads_sfixed(2.2 * real(240 - l) / 480.0));
                    color_index := compute_point(c);
                    color := vga_color_map((color_index mod 4));

                    write(output_file, integer'image(to_integer(unsigned(color(0)))) & " " & integer'image(to_integer(unsigned(color(1)))) & " " & integer'image(to_integer(unsigned(color(2)))) & LF);

                    
                end if;
            end loop;
        end loop;
        file_close(output_file);
    end procedure;

begin
    generate_set;
end architecture behavior;
