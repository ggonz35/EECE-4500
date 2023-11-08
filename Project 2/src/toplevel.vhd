library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ads_complex_pkg.all;
use work.vga_data.all;

-- Add your VGA configuration and color map setup here

procedure generate_set is
    generic
    (
        iterations: positive := 256 -- You can adjust the number of iterations
    );
    variable c: ads_complex;
    variable color_index: natural;
    variable color: std_logic_vector(3 downto 0);

begin
    for l in 0 to 479 loop
        for p in 0 to 639 loop
            if x_visible(make_coordinate(p, l)) and y_visible(make_coordinate(p, l)) then
                c := ads_cmplx((3.2 * to_ads_sfixed(p) / 640.0 - 2.2), (2.2 * (240 - l) / 480.0));
                color_index := compute_point(c, iterations);
                color := vga_color_map(color_index);
                -- Plot the color at the specified VGA coordinates (p, l)
                -- You'll need to adapt this part to your specific VGA output logic
            end if;
        end loop;
    end loop;
end procedure;
               
function compute_point(c: in ads_complex; iterations: in positive) return natural is
    variable z: ads_complex := complex_zero;
    variable iteration: natural := 0;
    constant threshold: ads_sfixed := to_ads_sfixed(4.0); -- You can adjust the threshold
begin
    while iteration < iterations loop
        z := (z * z) + c;
        if abs2(z) > threshold then
            return iteration;
        end if;
        iteration := iteration + 1;
    end loop;
    return 0;
end function compute_point;
