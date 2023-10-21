library ieee;
use ieee.std_logic_1164.all;

library class_library;
use class_library.project_pkg.adder;

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
	-- internal signals
	signal carry_chain:	std_logic_vector(chain_size downto 0);
begin
	-- drive carry
	carry_out <= carry_chain(chain_size);
	carry_chain(0) <= carry_in;
	
	-- generate ripple carry adder
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