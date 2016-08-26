`include "../define.v"
`include "../regfile.v"
module regfile_tb;
	reg clk, rst;
	reg[`RegAddrWidth-1:0]	waddr;
	reg[`RegDataWidth-1:0]	wdata;
	reg						we;

	// read port1
	reg						re1;
	reg[`RegAddrWidth-1:0]	raddr_1;
	wire[`RegDataWidth-1:0]	rdata_1;

	// read port2
	reg						re2;
	reg[`RegAddrWidth-1:0]	raddr_2;
	wire[`RegDataWidth-1:0]	rdata_2;
	regfile regs(clk, rst, waddr, wdata, we, re1, raddr_1, rdata_1, re2, raddr_2, rdata_2);
	initial begin
		clk = 1;
		forever #1 clk = ~clk;
	end

	initial begin : test
		integer i;
		$dumpfile("vcd/regfile_tb.vcd");
		$dumpvars;
		$readmemb("testData/data.data", regs.regs);
		rst = ~`RstEnable;
		re1 = `ReadEnable;
		for (i = 0; i < `RegNum; i = i + 1) begin
			#1 raddr_1 = i;
			#1 $display("now reading from read port 1: %32b", rdata_1);
		end
		re1 = ~`ReadEnable;
		$display("==============================================================");
		// for (i = 0; i < `RegNum; i = i + 1) begin
		// 	#1 raddr_2 = i;
		// 	#1 $display("now reading from read port 2: %32b", rdata_2);
		// end
		// $display("==============================================================");
		for (i = 0; i < `RegNum; i = i + 1) begin
			@(posedge clk) begin
				we = `WriteEnable;
				waddr = i;
				wdata = i;
				#1.5 we = ~`WriteEnable;
			end
			$display("now writting: %32b", wdata);
		end
		$display("==============================================================");
		re2 = `ReadEnable;
		for (i = 0; i < `RegNum; i = i + 1) begin
			#1 raddr_2 = i;
			#1 $display("now reading %2d", i, " from read port 2: %32b", rdata_2);
		end
		re2 = ~`ReadEnable;
		$display("==============================================================");
		rst = ~rst;
		re1 = `ReadEnable;
		for (i = 0; i < `RegNum; i = i + 1) begin
			#1 raddr_1 = i;
			#1 $display("now reading from read port 1: %32b", rdata_1);
		end
		re1 = ~`ReadEnable;
		$finish;
	end
endmodule