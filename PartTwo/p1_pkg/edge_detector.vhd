library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
	port (
		clock:	in	std_logic;
		reset:	in	std_logic;
		button:	in	std_logic;
		edge:	out	std_logic
	);
end entity edge_detector;

architecture behavioural of edge_detector is
	signal store: std_logic;	-- storage element
begin

	-- the idea here is that we want to have a one cycle pulse
	-- which is high when we have a falling edge on the button signal;
	-- we check for when the previous value of the signal was high and
	-- the current value is low
	edge <= store and not button;

	storage: process(clock, reset) is
	begin
		if reset = '0' then
			-- reset logic
			store <= '0';
		elsif rising_edge(clock) then
			-- on a rising edge of the clock, sample the signal
			store <= button;
		end if;
	end process storage;
end architecture behavioural;
