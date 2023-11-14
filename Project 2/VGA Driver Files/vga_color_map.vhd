library ieee;
use ieee.std_logic_1164.all;

use work.vga_data.all;

entity vga_color_map is
	port(
	color_index		: in natural;
	color_map_out	: out color_map
	);
end vga_color_map;


architecture vga_c_map of vga_color_map is
	type color_map_array_type is array(natural range<>) of color_map;
	constant my_color_map: color_map_array_type := (
			( red => "0000", green => "1111", blue => "0000" ),
			( red => "0001", green => "1110", blue => "0000" ),
			( red => "0010", green => "1101", blue => "0000" ),
			( red => "0011", green => "1100", blue => "0000" ),
			( red => "0100", green => "1011", blue => "0000" ),
			( red => "0101", green => "1010", blue => "0000" ),
			( red => "0110", green => "1001", blue => "0000" ),
			( red => "0111", green => "1000", blue => "0000" ),
			( red => "1000", green => "0111", blue => "0000" ),
			( red => "1001", green => "0110", blue => "0000" ),
			( red => "1010", green => "0101", blue => "0000" ),
			( red => "1011", green => "0100", blue => "0000" ),
			( red => "1100", green => "0011", blue => "0000" ),
			( red => "1101", green => "0010", blue => "0000" ),
			( red => "1110", green => "0001", blue => "0000" ),
			( red => "1111", green => "0000", blue => "0000" )
		);

	begin
		color_map_out <= my_color_map(color_index);
--		color_map 	: process(color_index, color_map_out)
--		begin
--			if color_index = '0' then
--				color_map_out.red   <= "0000"; 
--				color_map_out.green <= "1111";
--				color_map_out.blue  <= "0000";
--			elsif color_index = '1' then
--				color_map_out.red   <= "0000";
--				color_map_out.green <= "0000";
--				color_map_out.blue  <= "1111";
--			elsif color_index = '2' then
--				color_map_out.red   <= "1111";
--				color_map_out.green <= "0000";
--				color_map_out.blue  <= "0000";
--			else
--				color_map_out.red   <= "0000";
--				color_map_out.green <= "0000";
--				color_map_out.blue  <= "0000";
--			end if;
--	end process color_map;
end vga_c_map;
