library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

entity vga_fsm is
    generic (
        vga_res:    vga_timing := vga_res_default
    );
    port (
        vga_clock:      in  std_logic;
        reset:          in  std_logic;

        point:          out coordinate;
        point_valid:    out boolean;

        h_sync:         out std_logic;
        v_sync:         out std_logic
    );
end entity vga_fsm;

architecture fsm of vga_fsm is
--    signal current_point: coordinate := (others => 0);  -- Initialize to (0, 0)
--    signal next_point: coordinate := (others => 0);     -- Initialize to (0, 0)
--    signal horizontal_counter: natural := 0;
--    signal vertical_counter: natural := 0;
--    signal h_sync_pulse: std_logic := '0';
--    signal v_sync_pulse: std_logic := '0';

	signal current_point: coordinate;

begin

	update_pt: process(vga_clock, reset) is
	begin
		if reset = '0' then
			current_point <= make_coordinate(0, 0);
		elsif rising_edge(vga_clock) then
			current_point <= next_coordinate(current_point, vga_res);
		end if;
	end process;

	drive_outs: process(vga_clock) is
	begin
		if rising_edge(vga_clock) then
			point <= current_point;
			h_sync <= do_horizontal_sync(current_point, vga_res);
			v_sync <= do_vertical_sync(current_point, vga_res);
			point_valid <= point_visible(current_point, vga_res);
		end if;
	end process drive_outs;
--    process(vga_clock, reset)
--    begin
--        if reset = '1' then
--            -- Reset the counters and VGA signals
--            horizontal_counter <= 0;
--            vertical_counter <= 0;
--            h_sync_pulse <= '0';
--            v_sync_pulse <= '0';
--            point_valid <= false;
--            point <= (x => 0, y => 0);
--        elsif rising_edge(vga_clock) then
--            -- Increment the counters and generate VGA signals
--            if horizontal_counter < vga_res.horizontal.active - 1 then
--                horizontal_counter <= horizontal_counter + 1;
--            else
--                horizontal_counter <= 0;
--                if vertical_counter < vga_res.vertical.active - 1 then
--                    vertical_counter <= vertical_counter + 1;
--                else
--                    vertical_counter <= 0;
--                end if;
--            end if;
--
--            -- Generate the next VGA coordinate
--            next_point <= next_coordinate(current_point, vga_res);
--
--            -- Generate sync pulses
--            h_sync_pulse <= do_horizontal_sync(current_point, vga_res);
--            v_sync_pulse <= do_vertical_sync(current_point, vga_res);
--
--            -- Update the current point with the next point
--            current_point <= next_point;
--            point_valid <= point_visible(current_point, vga_res);
--            point <= current_point;
--
--        end if;
--    end process;
--
--    h_sync <= h_sync_pulse;
--    v_sync <= v_sync_pulse;

end architecture fsm;
 
