library ieee;
use ieee.std_logic_1164.all;
use work.ads_complex.all;
use work.ads_fixed.all;
use work.pipeline_stage_package.all

entity pipeline_stage is
    -- Set default values
    generic(
        threshold: ads_sfixed := to_ads_sfixed(64);
        stage_number: natural := 20
    );
    port(
        -- Define input and output of pipeline stage
        stage_input: in complex_record;
        stage_output: out complex_record
    );
end pipeline_stage;

architecture behavior of pipeline_stage is
    -- Create signals for temporary usage
    signal z_re_sq, z_im_sq, z_re_im: ads_sfixed;
    signal z_overflow: boolean;
begin

    -- Makes stage_data output equal to stage_data input unless we get an overflow, then set stage_data output to stage_number
    stage_output.stage_data <= stage_input.stage_data when stage_input.stage_overflow else stage_number;

    -- set the output overflow to true if a previous stage overflowed or if z overflowed this time
    stage_output.stage_overflow <= stage_input.stage_overflow or z_overflow;

    -- assign C output as it is
    stage_output.c <= stage_input.c;

    -- compute products

    -- z're * z'im
    z_re_im <= stage_input.z.re * stage_input.z.im;

    -- z're^2
    z_re_re <= stage_input.z.re * stage_input.z.re;

    -- z'im^2
    z_im_im <= stage_input.z.im * stage_input.z.im;

    -- z_out're = z're^2 - z'im^2 + c're
    stage_output.z.re <= z_re_re - z_im_im + stage_input.c.re;

    -- z_out'im = 2* (z're * z'im) + c'im
    stage_output.z.im <= z_re_im + z_re_im + stage_input.c.im;

    -- calculate if value is larger than threshold
    z_overflow <= (z_re_re + z_im_im) > threshold;

end behavior;