`ifndef PIPELINE_DEF
`include "define.v"
`endif
module regfile(clk, rst, waddr, wdata, we, re1, raddr_1, rdata_1, re2, raddr_2, rdata_2);

	input 							clk;
	input 							rst;
	// write port
	input[`RegAddrWidth-1:0]		waddr;
	input[`RegDataWidth-1:0]		wdata;
	input							we;

	// read port1
	input							re1;
	input[`RegAddrWidth-1:0]		raddr_1;
	output reg[`RegDataWidth-1:0]	rdata_1;

	// read port2
	input							re2;
	input[`RegAddrWidth-1:0]		raddr_2;
	output reg[`RegDataWidth-1:0]	rdata_2;

	reg[`RegDataWidth-1:0] regs[`RegNum-1:0];

	// reset all regs
	always @(posedge clk) begin : proc_reset
		integer i;
		if (rst == `RstEnable) begin
			for (i = 0; i < `RegNum; i = i + 1)
				regs[i] <= 0;
		end
	end
	// write operation
	// Now set the write process finish by the first half of the period
	always @(negedge clk) begin : proc_write
		if (rst == ~`RstEnable)
			if ((we == `WriteEnable) && (waddr != `RegAddrWidth'b0))
				regs[waddr] <= wdata;
	end

	// read port1
	always @(re1, rst, raddr_1) begin : proc_read1
		if (re1 == `ReadEnable && rst == ~`RstEnable)
			rdata_1 <= regs[raddr_1];
		else
			rdata_1 <= `ZeroWord;
	end

	// read port2
	always @(re2, rst, raddr_2) begin : proc_read2
		if (re2 == `ReadEnable && rst == ~`RstEnable)
			rdata_2 <= regs[raddr_2];
		else
			rdata_2 <= `ZeroWord;
	end
endmodule