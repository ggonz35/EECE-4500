library ieee;
use ieee.std_logic_1164.all;


entity vga_color_map is
	port(
	color_index		: in std_logic;
	color_map_out		: out color_map
	);
end vga_color_map;


architecture vga_c_map of vga_color_map is

	begin
		color_map 	: process(color_index, color_map_out)
		begin
			if color_index = '0' then
				color_map_out.red   <= "0000"; 
				color_map_out.green <= "0000";
				color_map_out.blue  <= "1111";
			elsif color_index = '1' then
				color_map_out.red   <= "0000";
				color_map_out.green <= "1111";
				color_map_out.blue  <= "0000";
			elsif color_index = '2' then
				color_map_out.red   <= "1111";
				color_map_out.green <= "0000";
				color_map_out.blue  <= "0000";
			else
				color_map_out.red   <= "0000";
				color_map_out.green <= "0000";
				color_map_out.blue  <= "0000";
			end if;
	end process color_map;
end vga_c_map;
