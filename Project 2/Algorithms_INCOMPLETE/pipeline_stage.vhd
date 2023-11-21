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
        rst: in std_logic;
        clk: in std_logic
    );
end pipeline_stage;

architecture behavior of pipeline_stage is
    signal stage_input: complex_record;
    signal stage_output: complex_record;
begin

    stage_output.stage_data <= stage_input.stage_data when

end behavior;