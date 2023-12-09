library ieee;
use ieee.std_logic_1164.all;

entity sync_stage is
	generic (
		input_width: positive := 16
	);
	port (
		clk_in:	 in	 std_logic;
	
		bin_in:	 in	 std_logic_vector(input_width - 1 downto 0);
		bin_out:	 out	 std_logic_vector(input_width - 1 downto 0)
	);
end entity sync_stage;

architecture sync of sync_stage is

	component sync_ff is
		generic(
			input_width: positive := 16
		);
		port(
		);
	end component sync_ff;
	
	component binary_to_gray is
		generic(
			input_width: positive := 16
		);
		port(
		);	
	end component binary_to_gray;
	
	component gray_to_binary is
		generic(
			input_width: positive := 16
		);
		port(
		);	
	end component gray_to_binary
begin



end architecture sync;
