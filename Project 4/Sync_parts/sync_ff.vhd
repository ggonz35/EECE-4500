library ieee;
use ieee.std_logic_1164.all;

entity sync_ff in
	generic(
		input_width: positive := 16
	);
	port(
		clk			:in	std_logic;
		rst			:in	std_logic;
		in_data		:in	std_logic_vector(input_width - 1 downto 0);
		
		out_data		:out	std_logic_vector(input_width - 1 downto 0)
	);
	
architecture flip_floop of sync_3 is
		signal ff_1:		std_logic_vector(input_width - 1 downto 0);
		signal ff_2:		std_logic_vector(input_width - 1 downto 0);
begin

	if rising_edge(clk) then	
		if rst = '0' then
		
			ff_1 		<= in_data;
			ff_2 		<= ff_1;
			out_data <= ff_2;
		
		end if;
	end if;

end architecture flip_floop;
