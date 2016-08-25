`ifndef PIPELINE_DEF
`include "../define.v"
`endif
module mux2x1(in_0, in_1, slct, out);

	parameter data_width = 1;

	input[data_width-1:0]	in_0;
	input[data_width-1:0]	in_1;
	input					slct;
	output[data_width-1:0]	out;

	assign out = slct ? in_1 : in_0;
endmodule // mux2x1