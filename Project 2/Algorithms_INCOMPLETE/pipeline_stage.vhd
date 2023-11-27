library ieee;
use ieee.std_logic_1164.all;
use work.ads_complex.all;
use work.ads_fixed.all;
use work.pipeline_stage_package.all

entity pipeline_stage is
    generic(
        threshold: ads_sfixed := to_ads_sfixed(64);
        stage_number: natural := 20
    );
    port(
        stage_input: in complex_record;
        stage_output: out complex_record
		--pls_in:  in std_logic;
		--pls_out: out std_logic
    );
end pipeline_stage;

architecture behavior of pipeline_stage is
    --signal stage_input: complex_record;
    --signal stage_output: complex_record;
    signal z_re_sq, z_im_sq, z_re_im: ads_sfixed;
    signal z_overflow: boolean;
begin

    -- The stage_data output should be the value on the stage_data input if the stage_overflow
    -- input is true, else it should be the current stage number.
    stage_output.stage_data <= stage_input.stage_data when stage_input.stage_overflow else stage_number;

    -- 
    stage_output.stage_overflow <= stage_input.stage_overflow or (z_overflow);

    -- assign C output as it is
    stage_output.c <= stage_input.c;

    -- compute products
    z_re_im <= stage_input.z.re * stage_input.z.im;
    z_re_re <= stage_input.z.re * stage_input.z.re;
    z_im_im <= stage_input.z.im * stage_input.z.im;

    stage_output.z.re <= z_re_re - z_im_im + stage_input.c.re;
    stage_output.z.im <= z_re_im + z_re_im + stage_input.c.im;

    z_overflow <= (z_re_re + z_im_im) > threshold;

   --z_real_part_temp <= (stage_input.z.real_part ** 2) - (stage_input.z.imaginary_part ** 2) + stage_input.c.real_part;

   --z_imaginary_part_temp <= (2.0 * stage_input.z.real_part * stage_input.z.imaginary_part) + stage_input.c.imaginary_part; 
     -- Calculate overflow flags for z and c
   --z_overflow <= (abs(z_real_part_temp) > threshold) or (abs(z_imaginary_part_temp) > threshold);

   --c_overflow <= (abs(stage_input.c.real_part) > threshold) or (abs(stage_input.c.imaginary_part) > threshold);   -- Use temporary values to update z
   
   stage_output.z.real_part <= z_real_part_temp;

   stage_output.z.imaginary_part <= z_imaginary_part_temp;

end behavior;