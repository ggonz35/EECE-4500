library ieee;
use ieee.std_logic_1164.all;
use work.ads_complex.all;
use work.ads_fixed.all;
use work.pipeline_stage_package.all

entity pipeline_stage is
    generic(
        threshold: ads_sfixed := 64;
        stage_number: natural := 20
    );
    port(
        pls_rst: in std_logic;
        pls_clk: in std_logic;
		  
		pls_in:  in std_logic;
		pls_out: out std_logic
    );
end pipeline_stage;

architecture behavior of pipeline_stage is
    signal stage_input: complex_record;
    signal stage_output: complex_record;
begin

    --perform computations and complete assignments
   -- Calculate stage_data and stage_overflow based on the rules
   stage_output.stage_data <= stage_input.stage_data when stage_input.stage_overflow else stage_number;

   stage_output.stage_overflow <= stage_input.stage_overflow or (z_overflow or c_overflow); -- Assign c output as it is
   stage_output.c <= stage_input.c;   -- Compute z^2 + c

   z_real_part_temp <= (stage_input.z.real_part ** 2) - (stage_input.z.imaginary_part ** 2) + stage_input.c.real_part;

   z_imaginary_part_temp <= (2.0 * stage_input.z.real_part * stage_input.z.imaginary_part) + stage_input.c.imaginary_part; 
     -- Calculate overflow flags for z and c
   z_overflow <= (abs(z_real_part_temp) > threshold) or (abs(z_imaginary_part_temp) > threshold);

   c_overflow <= (abs(stage_input.c.real_part) > threshold) or (abs(stage_input.c.imaginary_part) > threshold);   -- Use temporary values to update z
   
   stage_output.z.real_part <= z_real_part_temp;
   
   stage_output.z.imaginary_part <= z_imaginary_part_temp;

end behavior;
