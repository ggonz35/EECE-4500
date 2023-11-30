set vga_pins { \
		{ AA1  V1  Y2  Y1 } \
		{  W1  T2  R2  R1 } \
		{  P1  T1  P4  N2 } \
	}

set vga_colors { red green blue }

for { set c 0 } { ${c} < 3 } { incr c } {
	set color [ lindex ${vga_colors} ${c} ]
	for { set b 0 } { ${b} < 4 } { incr b } {
		set pin [ lindex [ lindex ${vga_pins} ${c} ] ${b} ]
		set_location_assignment PIN_${pin} -to color.${color}\[${b}\]
		set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to color.${color}\[${b}\]
	}
}