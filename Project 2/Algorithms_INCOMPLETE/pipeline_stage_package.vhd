package pipeline_stage_package is

    type complex_record is record
        z: ads_complex;
        c: ads_complex;
        stage_data: natural;
        stage_overflow: boolean;
    end complex_record;

    function pipeline_component (z: ads_complex, c: ads_complex) return ads_complex is
        variable return_value;
    begin
        return_value = z*z + c;
    end function pipeline_component;

end pipeline_stage_package;