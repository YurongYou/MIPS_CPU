`ifndef PIPELINE_DEF
`include "define.v"
`endif

module hilo_reg (

	input clk,
	input rst,

	input we_hi,
	input[`RegDataWidth-1:0] hi_data_in,

	input we_lo,
	input[`RegDataWidth-1:0] lo_data_in,

	output reg[`RegDataWidth-1:0] hi_data_out,
	output reg[`RegDataWidth-1:0] lo_data_out
);

	// reset all regs
	always @(posedge clk) begin : proc_reset
		if (rst == `RstEnable) begin
			hi_data_out <= `ZeroWord;
			lo_data_out <= `ZeroWord;
		end
	end

	// write operation
	// Now set the write process finish by the first half of the period
	always @(negedge clk) begin : proc_write
		if (rst == ~`RstEnable) begin
			if (we_hi == `WriteEnable) hi_data_out <= hi_data_in;
			if (we_lo == `WriteEnable) lo_data_out <= lo_data_in;
		end
	end

	// read control
	always @(*) begin
		if (rst == `ReadEnable) begin
		end
		else begin
			hi_data_out <= `ZeroWord;
			lo_data_out <= `ZeroWord;
		end
	end
endmodule