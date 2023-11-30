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
			( red => "0000", green => "0000", blue => "1111" ),
			( red => "0001", green => "0000", blue => "1110" ),
			( red => "0010", green => "0000", blue => "1101" ),
			( red => "0011", green => "0000", blue => "1100" ),
			( red => "0100", green => "0000", blue => "1011" ),
			( red => "0101", green => "0000", blue => "1010" ),
			( red => "0110", green => "0000", blue => "1001" ),
			( red => "0111", green => "0000", blue => "1000" ),
			( red => "1000", green => "0000", blue => "0111" ),
			( red => "1001", green => "0000", blue => "0110" ),
			( red => "1010", green => "0000", blue => "0101" ),
			( red => "1011", green => "0000", blue => "0100" ),
			( red => "1100", green => "0000", blue => "0011" ),
			( red => "1101", green => "0000", blue => "0010" ),
			( red => "1110", green => "0000", blue => "0001" ),
			( red => "1111", green => "0000", blue => "0000" ),
			( red => "1111", green => "0000", blue => "0001" ),
			( red => "1111", green => "0000", blue => "0010" ),
			( red => "1111", green => "0000", blue => "0011" ),
			( red => "1111", green => "0000", blue => "0100" ),
			( red => "1111", green => "0000", blue => "0101" ),
			( red => "1111", green => "0000", blue => "0110" ),
			( red => "1111", green => "0000", blue => "0111" ),
			( red => "1111", green => "0000", blue => "1000" ),
			( red => "1111", green => "0000", blue => "1001" ),
			( red => "1111", green => "0000", blue => "1010" ),
			( red => "1111", green => "0000", blue => "1011" ),
			( red => "1111", green => "0000", blue => "1100" ),
			( red => "1111", green => "0000", blue => "1101" ),
			( red => "1111", green => "0000", blue => "1110" ),
			( red => "1111", green => "0000", blue => "1111" )
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
