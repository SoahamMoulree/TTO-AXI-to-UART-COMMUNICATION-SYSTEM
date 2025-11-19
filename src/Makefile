# Makefile for QuestaSim UVM Verification
QUESTA := /home/share/questa.csh
SHELL := /bin/csh

# Default target
all: compile_with_coverage

# Source Questa environment
source_questa:
	source $(QUESTA)

# Coverage target 1: Basic coverage
coverage: source_questa
	vlog -sv +acc +cover +fcover -l top.log package.sv top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details
	vim transcript

# Coverage target 2: With exclusion file
coverage_with_exclusion: source_questa
	vlog -sv +acc +cover +fcover -l evm.log top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "do ../coverage/exclusion.do; coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details
	vim transcript

# Alias for shorter commands
cov: coverage
cov_ex: coverage_with_exclusion

# Clean targets
clean:
	rm -rf work/
	rm -f *.log
	rm -f transcript
	rm -f vsim.wlf

clean_coverage:
	rm -rf coverage.ucdb
	rm -rf covReport/

clean_all: clean clean_coverage

# Help target
help:
	@echo "Available targets:"
	@echo "  coverage           - Run with basic coverage collection"
	@echo "  cov                - Alias for coverage"
	@echo "  coverage_with_exclusion - Run with exclusion file"
	@echo "  cov_ex             - Alias for coverage_with_exclusion"
	@echo "  clean              - Remove simulation files"
	@echo "  clean_coverage     - Remove coverage files"
	@echo "  clean_all          - Remove all generated files"
	@echo "  help               - Show this help message"

.PHONY: all source_questa coverage coverage_with_exclusion cov cov_ex clean clean_coverage clean_all help
