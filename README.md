# MIPS_CPU
Implement a CPU which supports a subset of MIPS operations using Verilog HDL on FPGA Xilinx Basys 3

## TODOs
1. finish construction
	
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
		* [ ] arithmetic operations
		* [ ] memory store/load
		* [ ] logic operations
		* [ ] hi/lo operations
		* [ ] dependency test (forwarding)
		* [ ] jump operations
		* [ ] overall test
4. improvement
	* add cache
5. synthesis

