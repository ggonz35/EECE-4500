library ieee;
use ieee.std_logic_1164.all;


type color_map is record

	red	: std_logic_vector (0 to 3);
	green	: std_logic_vector (0 to 3);
	blue	: std_logic_vector (0 to 3)

end record color_map;


entity vga_color_map is
	port(
	color_index		: in std_logic;
	color_map_out	: out color_map
	);
end vga_color_map;

architecture vga_c_map of vga_color_map is
	--declarative empty atm

	begin
		color_map 	: process(color_index, color_map_out)
		begin
		for i in 0 to 3 loop
			if color_index = '0' then
				color_map_out[i].red   <= '0000' 
				color_map_out[i].green <= '0000'
				color_map_out[i].blue  <= '1111'
			elsif color_index = '1' then
				color_map_out[i].red   <= '1111'
				color_map_out[i].green <= '0000'
				color_map_out[i].blue  <= '1111'
			elsif color_index = '2' then
				color_map_out[i].red   <= '1111'
				color_map_out[i].green <= '0000'
				color_map_out[i].blue  <= '0000'
			else
				color_map_out[i].red   <= '0000'
				color_map_out[i].green <= '0000'
				color_map_out[i].blue  <= '0000'
			end if;
		end loop;
	end process color_map;
end vga_c_map;
