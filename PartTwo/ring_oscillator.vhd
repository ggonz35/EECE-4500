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
	signal result: std_logic;
	
begin
	assert <condition to check using ro_length>
		report "ro_length must be an odd number"
		severity failure;

	-- place nand gate
	-- one input is enable, the other one the output of the last inverter
	-- output goes into the first inverter in the chain
		result <= enable nand osc_out;
		

	-- place inverters
	-- for ... generate
	-- end generate
	
		for i in 1 to ro_length generate
			osc_out(i) <= not osc_out(i-1);
		end generate;

	-- drive osc_out with output of last inverter in the chain
	osc_cout <= ...;
end architecture gen;
