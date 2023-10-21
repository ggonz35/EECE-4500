library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port (
		a:	in	std_logic;
		b:	in	std_logic;
		ci:	in	std_logic;
		s:	out	std_logic;
		co:	out	std_logic
	);
end entity adder;

architecture gate_level of adder is
	signal p_sum: std_logic_vector(1 downto 0);
	signal p_carry: std_logic_vector(1 downto 0);
begin
	-- drive outputs
	s <= p_sum(1);
	co <= p_carry(1) or p_carry(0);	-- co <= or p_carry;

	-- internal logic
	p_sum(0) <= a xor b;
	p_sum(1) <= p_sum(0) xor ci;
	
	p_carry(0) <= a and b;
	p_carry(1) <= p_sum(0) and ci;
end architecture gate_level;