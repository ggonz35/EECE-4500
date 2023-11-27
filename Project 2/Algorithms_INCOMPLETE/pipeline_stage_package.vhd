package pipeline_stage_package is

    type complex_record is record
        z: ads_complex;
        c: ads_complex;
        stage_data: natural;
        stage_overflow: boolean;
    end complex_record;

end pipeline_stage_package;