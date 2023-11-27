
entity pipeline is
    generic (
        pipeline_length:    positive := 16;
        threshold:          ads_sfixed := to_ads_sfixed(4)
    );
    port (
        clock:  in  std_logic;
        reset:  in  std_logic;
        c:      in  ads_complex;
        z:      in  ads_complex;

        ov_out: out natural
    );
end entity pipeline;

architecture rtl of pipeline is
    type stage_array_type is array(0 to pipeline_length) of complex_record;

    signal pipeline_in: stage_array_type;
    signal pipeline_out: stage_array_type;
begin

    -- populate input to first stage
    pipeline_in(0).z <= z;
    pipeline_in(0).c <= c;
    pipeline_in(0).stage_data <= 0;
    pipeline_in(0).stage_overflow <= false;

    -- get the finalized output for the last stage
    ov_out <= pipeline_in(pipeline_length).stage_data;

    stages: for i in 0 to pipeline_length - 1 generate
        s: pipeline_stage
            generic map (
                threshold => threshold,
                stage_number => i
            )
            port map (
                stage_input => pipeline_in(i),
                stage_output => pipeline_out(i)
            );

        store: process(clock, reset) is
        begin
            if reset = '0' then
                pipeline_in(i+1) <= ( z => complex_zero, c => complex_zero, stage_data => 0, stage_overflow => false);
            elsif rising_edge(clock) then
                pipeline_in(i+1) <= pipeline_out(i);
            end if;
        end process store;

    end generate stages;


end architecture rtl;