library ieee;
use ieee.std_logic_1164.all;

use work.ads_complex_pkg.all;

entity compute_point is
    generic (
        threshold: real := 64.0;  -- Set an appropriate value
        iterations: natural := 100;  -- Set an appropriate value
        stage_number: natural := 42   -- Set an appropriate value
    );
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        stage_input : in PipelineRecord;
        stage_output : out PipelineRecord
    );
end entity compute_point;

architecture set_gen of compute_point is
    -- signal declaration
    signal z_real_part_temp, z_imaginary_part_temp : real;
    signal z_overflow, c_overflow : boolean;

-- Creates a type called color_map_array with a size of maximum iterations
type color_map_array is array (natural range <>) of ads_complex;

signal my_color_map : color_map_array(0 to iterations - 1) :=
    (others => (re => to_ads_sfixed(0), im => to_ads_sfixed(0)));

begin
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset logic if needed
            -- ...
        elsif rising_edge(clk) then
            -- Your pipeline stage logic here

            -- Call the procedure with appropriate parameters
            compute_point_procedure(stage_input, iterations, my_color_map, stage_output);

            -- Compute z^2 + c
            z_real_part_temp <= (stage_input.z.re ** 2) - (stage_input.z.im ** 2) + stage_input.c.re;
            z_imaginary_part_temp <= (2.0 * stage_input.z.re * stage_input.z.im) + stage_input.c.im;

            -- Calculate overflow flags for z and c
            z_overflow <= (abs(z_real_part_temp) > threshold) or (abs(z_imaginary_part_temp) > threshold);
            c_overflow <= (abs(stage_input.c.re) > threshold) or (abs(stage_input.c.im) > threshold);

            -- Use temporary values to update z
            stage_output.z.re <= z_real_part_temp;
            stage_output.z.im <= z_imaginary_part_temp;

            -- Update stage_output based on your pipeline logic				
				if stage_input.stage_overflow = '1' then
					stage_output.stage_data <= stage_input.stage_data;
				else
					stage_output.stage_data <= stage_number;
				end if;
				
            stage_output.stage_overflow <= stage_input.stage_overflow or (z_overflow or c_overflow);
            stage_output.c <= stage_input.c;

        end if;
    end process;
end architecture set_gen;
