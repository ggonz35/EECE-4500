library ieee;
use ieee.std_logic_1164.all;

entity generate_set is
	port();
	
end generate_set;


architecture set_gen of generate_set is
	-- signal decleration
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
        z := ads_square(z) + c;

            if abs2(z) > threshold then
                exit; -- not sure if using exit is correct but we need to break here
            end if;

        iteration := iteration + 1;
        color_map(iteration) := z;
     end loop;
	end procedure;
end compute_point