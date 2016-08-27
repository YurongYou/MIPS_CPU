`ifndef PIPELINE_DEF
`include "define.v"
`endif

module regfile(

	input 							clk,
	input 							rst,
	// write port
	input[`RegAddrWidth-1:0]		waddr,
	input[`RegDataWidth-1:0]		wdata,
	input							we,

	// read port1
	input							re1,
	input[`RegAddrWidth-1:0]		raddr_1,
	output reg[`RegDataWidth-1:0]	rdata_1,

	// read port2
	input							re2,
	input[`RegAddrWidth-1:0]		raddr_2,
	`ifdef DEBUG
	output reg[`RegDataWidth-1:0]	rdata_2,

	output[`RegDataWidth-1:0]		reg0,
	output[`RegDataWidth-1:0]		reg1,
	output[`RegDataWidth-1:0]		reg2,
	output[`RegDataWidth-1:0]		reg3,
	output[`RegDataWidth-1:0]		reg4,
	output[`RegDataWidth-1:0]		reg5,
	output[`RegDataWidth-1:0]		reg6,
	output[`RegDataWidth-1:0]		reg7,
	output[`RegDataWidth-1:0]		reg8,
	output[`RegDataWidth-1:0]		reg9,
	output[`RegDataWidth-1:0]		reg10,
	output[`RegDataWidth-1:0]		reg11,
	output[`RegDataWidth-1:0]		reg12,
	output[`RegDataWidth-1:0]		reg13,
	output[`RegDataWidth-1:0]		reg14,
	output[`RegDataWidth-1:0]		reg15,
	output[`RegDataWidth-1:0]		reg16,
	output[`RegDataWidth-1:0]		reg17,
	output[`RegDataWidth-1:0]		reg18,
	output[`RegDataWidth-1:0]		reg19,
	output[`RegDataWidth-1:0]		reg20,
	output[`RegDataWidth-1:0]		reg21,
	output[`RegDataWidth-1:0]		reg22,
	output[`RegDataWidth-1:0]		reg23,
	output[`RegDataWidth-1:0]		reg24,
	output[`RegDataWidth-1:0]		reg25,
	output[`RegDataWidth-1:0]		reg26,
	output[`RegDataWidth-1:0]		reg27,
	output[`RegDataWidth-1:0]		reg28,
	output[`RegDataWidth-1:0]		reg29,
	output[`RegDataWidth-1:0]		reg30,
	output[`RegDataWidth-1:0]		reg31
	`endif
	`ifndef DEBUG
	output reg[`RegDataWidth-1:0]	rdata_2
	`endif
);
	reg[`RegDataWidth-1:0] regs[`RegNum-1:0];

	`ifdef DEBUG
	assign reg0 = regs[0];
	assign reg1 = regs[1];
	assign reg2 = regs[2];
	assign reg3 = regs[3];
	assign reg4 = regs[4];
	assign reg5 = regs[5];
	assign reg6 = regs[6];
	assign reg7 = regs[7];
	assign reg8 = regs[8];
	assign reg9 = regs[9];
	assign reg10 = regs[10];
	assign reg11 = regs[11];
	assign reg12 = regs[12];
	assign reg13 = regs[13];
	assign reg14 = regs[14];
	assign reg15 = regs[15];
	assign reg16 = regs[16];
	assign reg17 = regs[17];
	assign reg18 = regs[18];
	assign reg19 = regs[19];
	assign reg20 = regs[20];
	assign reg21 = regs[21];
	assign reg22 = regs[22];
	assign reg23 = regs[23];
	assign reg24 = regs[24];
	assign reg25 = regs[25];
	assign reg26 = regs[26];
	assign reg27 = regs[27];
	assign reg28 = regs[28];
	assign reg29 = regs[29];
	assign reg30 = regs[30];
	assign reg31 = regs[31];
	`endif

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
	always @(*) begin : proc_read1
		if (re1 == `ReadEnable && rst == ~`RstEnable)
			rdata_1 <= regs[raddr_1];
		else
			rdata_1 <= `ZeroWord;
	end

	// read port2
	always @(*) begin : proc_read2
		if (re2 == `ReadEnable && rst == ~`RstEnable)
			rdata_2 <= regs[raddr_2];
		else
			rdata_2 <= `ZeroWord;
	end
endmodule