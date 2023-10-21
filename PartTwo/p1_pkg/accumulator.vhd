library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
	port (
		clock:	in	std_logic;
		enable:	in	std_logic;
		reset:	in	std_logic;
		data:	in	std_logic_vector(7 downto 0);
		output:	out	std_logic_vector(7 downto 0)
	);
end entity accumulator;

architecture arch1 of accumulator is
	-- component declarations
	component edge_detector is
		port (
			clock:	in	std_logic;
			reset:	in	std_logic;
			button:	in	std_logic;
			edge:	out	std_logic
		);
	end component edge_detector;

	-- internal signals
	signal storage:	std_logic_vector(data'range);	-- storage element
	signal enable_pulse: std_logic;					-- enable pulse
begin
	-- drive output
	output <= storage;

	-- edge detector circuit
	enable_detect: edge_detector
		port map (
				-- names before the '=>' are the ports of the component, their
				-- names must be the same as in the component declaration; think
				-- of these as "pins" in the component
				-- names after the '=>' are signals connected to those ports,
				-- their names can be any signal available in this architecture;
				-- we can use either internal signals or ports of the parent
				-- entity (accumulator)
				clock =>	clock,
				reset =>	reset,
				button =>	enable,
				edge =>		enable_pulse
			);
	
	-- accumulate process, triggered on changes to reset or clock
	accumulate: process(reset, clock) is
	begin
		if reset = '0' then
			-- if the reset line is '0' then clear the storage element
			storage <= (others => '0');
		elsif rising_edge(clock) then	-- clock'event and clock = '1'
			-- otherwise if we have a rising edge of the clock
			if enable_pulse = '1' then
				-- and the enable signal is set, do the addition and store it
				-- we can only add over types that define '+'
				-- we need to convert back into std_logic_vector
				storage <= std_logic_vector(unsigned(storage) + unsigned(data));
			end if;
		end if;
	end process accumulate;
end architecture arch1;