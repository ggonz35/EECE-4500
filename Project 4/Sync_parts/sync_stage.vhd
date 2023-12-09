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
			clk			:in	std_logic;
			rst			:in	std_logic;
			in_data		:in	std_logic_vector(input_width - 1 downto 0);
		
			out_data		:out	std_logic_vector(input_width - 1 downto 0)
		);
	end component sync_ff;
	
	component binary_to_gray is
		generic(
			input_width: positive := 16
		);
		port(
			bin_in: in std_logic_vector(input_width - 1 downto 0);
			gray_out: out std_logic_vector(input_width - 1 downto 0)
		);	
	end component binary_to_gray;
	
	component gray_to_binary is
		generic(
			input_width: positive := 16
		);
		port(
			gray_in: in std_logic_vector(input_width - 1 downto 0);
			bin_out: out std_logic_vector(input_width - 1 downto 0)
		);	
	end component gray_to_binary
begin

	b2g :		 binary_to_gray
		generic map(
			input_width	=> input_width
		);
		port map(
			bin_in 		=> bin_in,
			gray_out 	=> gray_in
		);
		
	g2b :		 gray_to_binary
		generic map(
			input_width	=> input_width
		);
		port map(
			gray_out		=> gray_in,
			bin_out 		=> bin_out
		);
		
	ff : 		sync_ff
		generic map(
			input_width	=> input_width
		);
		port map(
			clk			=> clk,
			rst			=> rst,
			gray_out		=> gray_in,
		
			gray_out		=> gray_in
		);
		
		
	flippity_floppity(clk,rst);
		


end architecture sync;
