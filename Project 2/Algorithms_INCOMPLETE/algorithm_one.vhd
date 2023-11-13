library ieee;
use ieee.std_logic_1164.all;
use work.ads.all;  -- Assuming ads_complex_pkg is in the work library

entity generate_set is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        stage_input : in PipelineRecord;
        stage_output : out PipelineRecord
    );
end generate_set;

architecture set_gen of generate_set is
    -- signal declaration
    signal z_real_part_temp, z_imaginary_part_temp : real;
    signal z_overflow, c_overflow : boolean;
    signal stage_data: natural;
    signal stage_overflow: boolean;

    -- Creates a type called color_map_array with a size of maximum iterations
    type color_map_array is array (natural range <>) of ads_complex;

    generic (
        threshold: positive := 64;
        iterations: natural := 100;  -- Set an appropriate value
    );

    procedure compute_point
        (variable c: in ads_complex;
         variable iterations: in natural;
         variable color_map: out color_map_array);
    end procedure;

    -- Define the PipelineRecord type
    type PipelineRecord is record
        z : ads_complex;
        c : ads_complex;
        stage_data : natural;
        stage_overflow : boolean;
    end record;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset logic if needed
            -- ...
        elsif rising_edge(clk) then
            -- Your pipeline stage logic here

            -- Initialize color_map_array
            signal my_color_map : color_map_array(0 to iterations - 1) := (others => ads_complex_pkg.complex_zero);

            -- Call the procedure with appropriate parameters
            compute_point(stage_input.c, iterations, my_color_map);

            -- Update stage_output based on your pipeline logic
            stage_output.z <= ...;  -- Update based on your logic
            stage_output.c <= ...;  -- Update based on your logic
            stage_output.stage_data <= ...;  -- Update based on your logic
            stage_output.stage_overflow <= ...;  -- Update based on your logic
        end if;
    end process;
end set_gen;
