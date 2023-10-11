library ieee;
use ieee.std_logic_1164.all;

entity ring_oscillator is
	generic(
		-- We want an odd number of inverters including the NAND
		inverter_amount: positive := 2
	);
	port(
		-- Ring oscillator enable
		enable: in std_logic;
		
		-- Output of ring oscillator
		output: out std_logic
	);
end entity ring_oscillator;

architecture circuit of ring_oscillator is
	signal result: std_logic;
begin

	-- NAND the input and the output
	result <= enable nand output;
	
	-- Create inverter_amount of inverters
	for current_result in inverter_amount - 1 downto 0
		result <= not result;
	end loop;
	
end architecture circuit; 
