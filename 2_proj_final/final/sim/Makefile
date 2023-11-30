.PHONY: all ads-tgt mandelbrot-tgt test-fixture clean

all: test-fixture

clean:
	-rm -f ads*.cf *.o work*.cf tb_mandelbrot

test-fixture: mandelbrot-tgt tb_mandelbrot.vhd
	ghdl analyze tb_mandelbrot.vhd
	ghdl elaborate tb_mandelbrot

ads-tgt:
	ghdl analyze --work=ads ../ads_fixed.vhd
	ghdl analyze --work=ads ../ads_complex.vhd

mandelbrot-tgt: ads-tgt
	ghdl analyze ../pipeline_stage_package.vhd
	ghdl analyze ../pipeline_stage.vhd
	ghdl analyze ../pipeline.vhd

#../vga_data.vhd
#../vga_fsm.vhd
