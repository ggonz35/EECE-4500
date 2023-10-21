library ieee;
use ieee.std_logic_1164.all;

library class_library;
use class_library.project_pkg.all;

entity carry_select_adder is
	generic (
		stage_sizes: stage_sizes_type := (2, 3, 5)
	);
	port (
		input_a:	in	std_logic_vector(adder_count(stage_sizes) - 1 downto 0);
		input_b:	in	std_logic_vector(adder_count(stage_sizes) - 1 downto 0);
		carry_in:	in	std_logic;
		
		final_sum:	out	std_logic_vector(adder_count(stage_sizes) - 1 downto 0);
		carry_out:	out	std_logic
	);
end entity carry_select_adder;

architecture csa of carry_select_adder is
	-- types
	type sum_chain_type is array(0 to 1) of std_logic_vector(final_sum'range);
	type carry_chain_type is array(0 to 1) of std_logic_vector(stage_sizes'range);
	type carry_selects_type is array(stage_sizes'range) of natural range 0 to 1;
	-- internal signals
	signal sum_chain: sum_chain_type;
	signal carry_chain: carry_chain_type;
	signal carry_selects: carry_selects_type;
begin
	-- generate adder groups
	top_adder_group: for s in stage_sizes'range generate
		constant lower_index: natural := cumulative_adders(stage_sizes, s);
		constant upper_index: natural := lower_index + stage_sizes(s) - 1;
	begin
		rca0: ripple_carry_adder
			generic map (
				chain_size =>	stage_sizes(s)
			)
			port map (
				operand_a =>	input_a(upper_index downto lower_index),
				operand_b =>	input_b(upper_index downto lower_index),
				carry_in =>		'0',
				sum =>			sum_chain(0)(upper_index downto lower_index),
				carry_out =>	carry_chain(0)(s)
			);
	end generate top_adder_group;

	bottom_adder_group: for s in stage_sizes'range generate
		constant lower_index: natural := cumulative_adders(stage_sizes, s);
		constant upper_index: natural := lower_index + stage_sizes(s) - 1;
	begin
		rca0: ripple_carry_adder
			generic map (
				chain_size =>	stage_sizes(s)
			)
			port map (
				operand_a =>	input_a(upper_index downto lower_index),
				operand_b =>	input_b(upper_index downto lower_index),
				carry_in =>		'1',
				sum =>			sum_chain(1)(upper_index downto lower_index),
				carry_out =>	carry_chain(1)(s)
			);
	end generate bottom_adder_group;
	
	-- carry selects
	carry_selects(0) <= 0 when carry_in = '0' else 1;
	carry_mux_selects: for s in 1 to carry_selects'high generate
		signal index: natural range 0 to 1;
	begin
		index <= carry_selects(s - 1);
		carry_selects(s) <= 0 when carry_chain(index)(s - 1) = '0' else 1;
	end generate carry_mux_selects;
	
	sum_mux: for s in stage_sizes'range generate
		constant lower_index: natural := cumulative_adders(stage_sizes, s);
		constant upper_index: natural := lower_index + stage_sizes(s) - 1;
		signal index: natural range 0 to 1;
	begin
		index <= carry_selects(s);
		final_sum(upper_index downto lower_index) <=
			sum_chain(index)(upper_index downto lower_index);
	end generate sum_mux;
	
	carry_out <= carry_chain(carry_selects(carry_selects'high))(stage_sizes'high);
	
end architecture csa;