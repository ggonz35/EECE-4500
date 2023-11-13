library ieee;
use ieee.std_logic_1164.all;

entity generate_set is
	port(
	clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       stage_input : in PipelineRecord;
       stage_output : out PipelineRecord
	);
	
end generate_set;


architecture set_gen of generate_set is
	-- signal decleration
	signal z_real_part_temp, z_imaginary_part_temp : real;
   signal z_overflow, c_overflow : boolean;
	signal stage_data: natural;
	signal stage_overflow: boolean;
-- Creates a type called color_map_array with a size of maximum iterations
type color_map_array is array (0 to iterations) of ads_complex;

begin

procedure compute_point
    -- Procedures dont return values so we need to define our output as a variable with type "out"
    (variable c: in ads_complex;
    variable iterations: in natural
    variable color_map: out color_map_array) is

    generic(
        threshold: positive := 64
    );

    variable z: ads_complex;
    variable iteration: natural; -- This is never a negative number bc its an iteration
begin
    -- Initialize z and iteration
     z := 0;
     iteration := 0;

     -- Loop iterations amount of times
     while iteration < iterations loop
                     --perform computations and complete assignments
			-- Calculate stage_data and stage_overflow based on the rules
			stage_output.stage_data <= stage_input.stage_data when stage_input.stage_overflow else stage_number;
			stage_output.stage_overflow <= stage_input.stage_overflow or (z_overflow or c_overflow);
			-- Assign c output as it is
			stage_output.c <= stage_input.c;
			-- Compute z^2 + c
			z_real_part_temp <= (stage_input.z.real_part ** 2) - (stage_input.z.imaginary_part ** 2) + stage_input.c.real_part;
			z_imaginary_part_temp <= (2.0 * stage_input.z.real_part * stage_input.z.imaginary_part) + stage_input.c.imaginary_part;
			-- Calculate overflow flags for z and c
			z_overflow <= (abs(z_real_part_temp) > threshold) or (abs(z_imaginary_part_temp) > threshold);
			c_overflow <= (abs(stage_input.c.real_part) > threshold) or (abs(stage_input.c.imaginary_part) > threshold);
			-- Use temporary values to update z
			stage_output.z.real_part <= z_real_part_temp;
			stage_output.z.imaginary_part <= z_imaginary_part_temp;
			
        iteration := iteration + 1;
        color_map(iteration) := z;
     end loop;
	end procedure;
end compute_point;
