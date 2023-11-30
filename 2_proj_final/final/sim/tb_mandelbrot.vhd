library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

use std.textio.all;

entity tb_mandelbrot is
	generic (
		pipeline_length: positive := 16;
		threshold: ads_sfixed := to_ads_sfixed(4)
	);
end entity tb_mandelbrot;

architecture test of tb_mandelbrot is
    component pipeline is
        generic (
            pipeline_length:    positive := 16;
            threshold:          ads_sfixed := to_ads_sfixed(4)
        );
        port (
            clock:  in  std_logic;
            reset:  in  std_logic;
            c:      in  ads_complex;
            z:      in  ads_complex;
    
            ov_out: out natural
        );
    end component pipeline;


    signal clock: std_logic := '0';
    signal test_done: boolean := false;

    signal reset: std_logic := '0';
    signal c, z: ads_complex;
    signal ov_out: natural;

begin
	dut: pipeline
		generic map (
			pipeline_length => pipeline_length,
			threshold => threshold
		)
		port map (
			clock => clock,
			reset => reset,
			c => c,
			z => z,
			ov_out => ov_out
		);

	-- mandelbrot seed definition
	z <= complex_zero;

	-- clock
	clock <= not clock after 5 ns when not test_done else '0';

	stimulus: process is
		constant max_value: natural := 100;
		constant delta_x: ads_sfixed := to_ads_sfixed(3.2/real(max_value));
		constant delta_y: ads_sfixed := to_ads_sfixed(-2.4/real(max_value));
		variable l: line;
	begin
		reset <= '0';
		wait until rising_edge(clock);
		reset <= '1';

		for y in 0 to max_value loop
			c.im <= delta_y * to_ads_sfixed(y) + to_ads_sfixed(1.2);
			for x in 0 to max_value loop
				c.re <= delta_x * to_ads_sfixed(x) + to_ads_sfixed(-2.2);
				wait until rising_edge(clock);
				write(l,
					integer'image(ov_out) & " " &
					integer'image(ov_out) & " " &
					integer'image(ov_out));
				writeline(output, l);
			end loop;
		end loop;

		test_done <= true;
		wait;
	end process stimulus;


end architecture test;
