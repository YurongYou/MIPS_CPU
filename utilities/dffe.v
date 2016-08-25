`ifndef PIPELINE_DEF
`include "../define.v"
`endif
//D_flip_flop with holding, update on posedge
module dffe (clk, rst, hold, data_in, data_out);
	parameter data_width = 1;

	input 						clk;
	input						rst;
	input						hold;
	input[data_width-1:0] 		data_in;
	output reg[data_width-1:0]	data_out;

	always @(posedge clk) begin
		if (rst == ~`RstEnable)	begin
			if (hold == ~`HoldEnable) begin
				data_out <= data_in;
			end
		end
		else
			data_out <= -4;
	end
endmodule