`ifndef PIPELINE_DEF
`include "../define.v"
`endif
module mux4x1(in_00, in_01, in_10, in_11, slct, out);

	parameter data_width = 1;

	input[data_width-1:0]	in_00;
	input[data_width-1:0]	in_01;
	input[data_width-1:0]	in_10;
	input[data_width-1:0]	in_11;
	input[1:0]				slct;
	output[data_width-1:0]	out;

	reg out;
	always @(*) begin
		case (slct)
			2'b00: out <= in_00;
			2'b01: out <= in_01;
			2'b10: out <= in_10;
			2'b11: out <= in_11;
		endcase // slct
	end // always @(*)
endmodule // mux2x1