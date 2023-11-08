-- THIS S********* AINT WORKING SMH DONT TRUST MY CODE
-- MISC Notes
-- Points go from 0 to 639
-- Points -> 3.2 * p / 640 - 2.2
-- Lines go from 0 to 479
-- Lines -> 2.2 * (240 - l) / 480

-- X and Y need to be converted to the imaginary
--  plane

-- Go to first line
-- Iterate through points
--  For each point, we convert the X and Y
--  Call the compute_point function
--  Get the color
--  Print the color at the converted coordinates

procedure generate_set

    generic(
        iterations: positive := 16
    );

    variable c: ads_complex;
    variable color: std_logic_vector(0 to 15); -- Some value between 0 and 255

begin

    for l in 0 to 479 loop
        for p in 0 to 639 loop
            c := ads_cmplx(3.2 * p / 640 - 2.2, 2.2 * (240 - l) / 480);
            color := compute_point(c);
            -- TODO: Add the plot functionality to this
        end loop;
    end loop;

end procedure;
