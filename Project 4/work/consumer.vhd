entity consumer is
    generic
    (

        DATA_WIDTH : natural := 8;
        ADDR_WIDTH : natural := 6

    );

    port
    (

        head: in natural range 0 to 2**ADDR_WIDTH - 1;
        tail: out natural range 0 to 2**ADDR_WIDTH - 1

    );
end entity consumer;

architecture behavior of consumer is

    -- Functions
    -- Returns true if head and tail have a distance apart greater than 1
    function can_advance (
        head_pointer: natural range 0 to 2**ADDR_WIDTH - 1; 
        tail_pointer: natural range 0 to 2**ADDR_WIDTH - 1
    ) return boolean is
        
    begin

        if tail_pointer > head_pointer and tail_pointer - head_pointer > 1 then
            return true;
        elsif head_pointer > tail_pointer and not (head_pointer = (2**ADDR_WIDTH - 1) or tail_pointer = 0) then
            return true;
        end if;

        return false;
    end function can_advance;

    type state_type is (start, wait_for_tail_advance, advance_tail);

    signal state, next_state: state_type := start;

    signal tail_ptr: natural range 0 to 2**ADDR_WIDTH - 1;
    signal tail_can_advance: boolean;

begin

    tail <= tail_ptr;
    tail_can_advance <= can_advance(head_ptr, tail);

    transition: process(state, conversion_end, head_can_advance) is
    begin
        case state is
            when start =>
                next_state <= wait_for_tail_advance;
            when wait_for_tail_advance =>
                if tail_can_advance then
                    next_state <= advance_tail;
                end if;
            when advance_tail =>
                next_state <= start;
        end case;
    end process transition;

    save_state: process(adc_clock, reset) is
    begin
        if reset = '0' then
            state <= start;
        elsif rising_edge(adc_clock) then
            state <= next_state;
        end if;
    end process save_state;

    output_function: process(adc_clock, reset) is
    begin
        if reset = '0' then
            state <= start;
        elsif rising_edge(adc_clock) then
            conversion_start <= '0';
            write_enable <= '0';
            case state is
                when start => null
                when wait_for_tail_advance => null
                when advance_tail =>
                    if tail_ptr = (2**ADDR_WIDTH - 1) then
                        tail_ptr <= 0;
                    else
                        tail_ptr <= head_ptr + 1;
                    end if;
            end case;
        end if;
    end process output_function;

end architecture behavior;
