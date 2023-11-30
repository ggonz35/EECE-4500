library ads;
use ads.ads_complex_pkg.all;
use ads.ads_fixed_pkg.all;


package pipeline_stage_package is

    type complex_record is record
        z: ads_complex;
        c: ads_complex;
        stage_data: natural;
        stage_overflow: boolean;
    end record complex_record;

    component pipeline_stage is
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
    end component pipeline_stage;

end pipeline_stage_package;
