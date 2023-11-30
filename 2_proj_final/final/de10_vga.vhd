package de10_vga is

	type de10_color is
	record
		red:		natural range 0 to 15;
		green:	natural range 0 to 15;
		blue:		natural range 0 to 15;
	end record de10_color;
	
	constant color_red: de10_color := ( red => 15, green => 0, blue => 0 );
	constant color_black: de10_color := ( others => 0 );

end package de10_vga;