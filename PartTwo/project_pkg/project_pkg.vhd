library ieee;
use ieee.std_logic_1164.all;

package project_pkg is
	-- type declarations
	type stage_sizes_type is array(natural range<>) of positive;

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
	
	component ripple_carry_adder is
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
	end component ripple_carry_adder;
	
	-- functions
	function adder_count (
			stage_sizes: in stage_sizes_type
		) return positive;
		
	function cumulative_adders (
			stage_sizes: in stage_sizes_type;
			stage_count: in natural
		) return natural;
end package project_pkg;

package body project_pkg is

	function adder_count (
			stage_sizes: in stage_sizes_type
		) return positive
	is
		variable ret: natural := 0;
	begin
		for s in stage_sizes'range loop
			ret := ret + stage_sizes(s);
		end loop;
		return ret;
	end function adder_count;

	function cumulative_adders (
			stage_sizes: in stage_sizes_type;
			stage_count: in natural
		) return natural
	is
		variable ret: natural := 0;
	begin
		if stage_count = 0 then
			return 0;
		end if;
		for s in 0 to stage_count - 1 loop
			ret := ret + stage_sizes(s);
		end loop;
		return ret;
	end function cumulative_adders;
end package body project_pkg;