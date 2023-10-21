library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
	generic (
		chain_size:	positive := 3
	);
	port (
		operand_a:	in	std_logic_vector(chain_size - 1 downto 0);
		operand_b:	in	std_logic_vector(chain_size - 1 downto 0);
		carry_in:	in	std_logic;
		
		sum:		out	std_logic_vector(chain_size - 1 downto 0);
		carry_out:	out	std_logic
	);
end entity ripple_carry_adder;

architecture rca of ripple_carry_adder is
	-- component declarations
	component adder is
		port (
			a:	in	std_logic;
			b:	in	std_logic;
			ci:	in	std_logic;
			s:	out	std_logic;
			co:	out	std_logic
		);
	end component adder;
	-- internal signals
	signal carry_chain:	std_logic_vector(chain_size downto 0);
begin

	rca_chain: for i in 0 to chain_size - 1 generate
		a: adder
			port map (
				a =>	operand_a(i),
				b =>	operand_b(i),
				ci =>	carry_chain(i),
				s =>	sum(i),
				co =>	carry_chain(i+1)
			);
	end generate rca_chain;

end architecture rca;