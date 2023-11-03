-- Procedures help us prevent repeating code
-- It is a function without a return value
-- To get values from a procedure you need to specify signals that are in or out

procedure compute_point()
    (variable c: in ads_complex;
    variable iterations: in natural) is -- TODO: include return value for colormap
    variable z: ads_complex;
    variable iteration: natural; -- This is never a negative number bc its an iteration
begin
    -- Initialize z and iteration
     z := 0;
     iteration := 0;

     -- Loop iterations amount of times
     while iteration < iterations loop
        z := ads_square(z) + c;
            if abs2(z) > threshold then -- TODO: we need to define threshold, not sure what value it is
                exit; -- not sure if using exit is correct but we need to break here
            end if;
            iteration := iteration + 1;
     end loop;

end procedure;