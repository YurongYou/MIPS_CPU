`include "../define.v"

module mux2x1(in_0, in_1, slct, out);

	parameter datawidth = 1;

	input[datawidth-1:0]	in_0;
	input[datawidth-1:0]	in_1;
	input					slct;
	output[datawidth-1:0]	out;

	assign out = slct ? in_1 : in_0;
endmodule // mux2x1