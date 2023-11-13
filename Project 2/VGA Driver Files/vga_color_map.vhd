library ieee;
use ieee.std_logic_1164.all;


entity vga_color_map is
	port(
	color_index		: in std_logic;
	color_map_out	: out std_logic_vector(0 to 3)
	);
end vga_color_map;

architecture vga_c_map of vga_color_map is
	--declarative empty atm

	begin
		color_map 	: process(color_index, color_map_out)
		begin
		for i in 0 to 3 loop
			if color_index = '0' then
				color_map_out[i] <= "000000000000";
			elsif color_index = '1' then
				color_map_out[i] <= "000000000000";
			elsif color_index = '2' then
				color_map_out[i] <= "000000000000";
			else
				color_map_out[i] <= "000000000000";
			end if;
		end loop;
	end process color_map;
end vga_c_map;