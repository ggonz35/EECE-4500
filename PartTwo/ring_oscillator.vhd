library ieee;
use ieee.std_logic_1164.all;

-- Our ring oscillator entity
entity ring_oscillator is
	-- Constant variables to be determined during synthesis
	-- Positive is any integer greater than but NOT equal to zero
	generic (
		ro_length:	positive	:= 13
	);

	-- Input is enable, the output is osc_out
	port (
		enable:		in	std_logic;
		osc_out:	out	std_logic
	);
end entity ring_oscillator;

-- Architecture is like a function of our ring_oscillator
-- This is where all the functionality is done
architecture gen of ring_oscillator is

	-- result is an array of ouputs for ro_length inverters
	signal result: std_logic_vector(0 to ro_length-1);

	-- Make sure VHDL does not optimize the NOT gates away
	attribute keep: boolean;
	attribute keep of result: signal is true;

	-- ro_out is the output signal of the circuit
	-- Need a new signal because we cant assign result directly to osc_out
	signal ro_out: std_logic;

begin

	-- place nand gate
	-- one input is enable, the other one the output of the last inverter
	-- output goes into the first inverter in the chain
	result(0) <= enable nand result(ro_length-1);
		
	-- place inverters
	-- for ... generate
	-- end generate
	gen_chain: for i in 1 to (ro_length - 1) generate
		
			result(i) <= not(result(i-1));
				
	end generate gen_chain;

	-- drive osc_out with output of last inverter in the chain
	ro_out <= result(ro_length-1);
	osc_out <= ro_out;
		
end architecture gen;