.PHONY: all ads-tgt mandelbrot-tgt test-fixture clean

all: test-fixture

clean:
	-rm -f ads*.cfg *.o work*.cfg tb_mandelbrot

test-fixture: mandelbrot-tgt tb_mandelbrot.vhd
	ghdl analyze tb_mandelbrot.vhd
	ghdl elaborate tb_mandelbrot

ads-tgt:
	ghdl analyze --work=ads ../ads_fixed.vhd
	ghdl analyze --work=ads ../ads_complex.vhd

mandelbrot-tgt: ads-tgt
	ghd analyze ../pipeline.vhd
	ghd analyze ../pipeline_stage_package.vhd
	ghd analyze ../pipeline_stage.vhd

#../vga_data.vhd
#../vga_fsm.vhd
