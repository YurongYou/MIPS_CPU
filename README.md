# MIPS_CPU
Implement a CPU which supports a subset of MIPS operations using Verilog HDL on FPGA Xilinx Basys 3

## TODOs
1. [x] finish construction

	* [x] `decoder.v`
	* [x]  `BranchControl.v`
	* [x]  `HazardControl.v`
	* [x]  `RM_ctrl.v`
	* [x]  `WM_ctrl.v`
	* [x]  solve div function
2. [x] fully review the pipeline code
3. test
	* [x] write virtual memory, rom
	* test on instrctions
		* [x] ori
		* [x] arithmetic operations
		* [x] memory store/load
		* [x] logic operations
		* [x] bitwise operations
		* [x] hi/lo operations
		* [x] dependency test (forwarding)
		* [x] jump operations
		* [ ] overall test
4. improvement
	* add cache
	* implememt CP0
5. synthesis
6. write report
	* clearly outline the supported instructions

