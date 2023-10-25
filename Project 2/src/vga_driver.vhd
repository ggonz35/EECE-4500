library ieee;
use ieee.std_logic_1164.all;

entity vga_driver is
	generic(
	);
	
	port(
	vga_clock:	in std_logic;
	reset:		in std_logic;
	x: 			out range;	
	y:				out range;
	hsync:		out std_logic;
	vsync:		out std_logic;
	x_valid:		out boolean;
	y_valid:		out boolean;
	);
	
end entity vga_driver;

architecture vga_driver is

begin

end architecture; 