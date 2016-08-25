`include "../define.v"
`include "../IF.v"
`include "../utilities/dffe.v"
`include "../utilities/mux2x1.v"
module IF_tb;
	reg 						clk;
	reg 						rst;
	reg							is_hold;
	reg							is_branch;
	reg[`InstAddrWidth-1:0]		branch_address;
	wire						ce;
	wire[`InstAddrWidth-1:0]	pc;	// connect to Instruction ROM
	wire[`InstAddrWidth-1:0]	pc_plus4; // connect to IF_ID

	IF inst_fetch(clk, rst, is_hold, is_branch, branch_address, ce, pc, pc_plus4);

	initial begin
		clk = 1;
		forever #1 clk = ~clk;
	end

	initial begin : test
		integer i;
		$dumpfile("vcd/IF_tb.vcd");
		$dumpvars;
		// you have to hold the rst for larger than 1 period to initialize the pc.
		rst = `RstEnable;
		#3 rst = ~`RstEnable;
		is_hold = ~`HoldEnable;
		is_branch = ~`BranchEnable;
		#10 is_hold = `HoldEnable;
		#10 is_hold = ~`HoldEnable;
		#10 is_branch = `BranchEnable;
		branch_address = 1234567;
		#1 @(negedge clk) is_branch = ~`BranchEnable;
		#10 rst = `RstEnable;
		#2 rst = ~`RstEnable;
		#10 $finish;
	end
endmodule