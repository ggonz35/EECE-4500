library ieee;
use ieee.std_logic_1164.all;

entity ring_oscillator is
	generic (
		ro_length:	positive	:= 13
	);
	port (
		enable:		in	std_logic;
		osc_out:	out	std_logic
	);
end entity ring_oscillator;

architecture gen of ring_oscillator is
	signal result: std_logic_vector(0 to ro_length-1);
	signal hold: std_logic;
	
begin

	-- place nand gate
	-- one input is enable, the other one the output of the last inverter
	-- output goes into the first inverter in the chain
		osc_out <= hold;
		result(0) <= enable nand hold;
		
		-- place inverters
		-- for ... generate
		-- end generate
		gen_chain: for i in 1 to (ro_length - 2) generate
		
				result(i) <= not result(i-1);
				
		end generate gen_chain;

	-- drive osc_out with output of last inverter in the chain
		hold <= result(ro_length-1);
		
end architecture gen;
