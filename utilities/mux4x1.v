`include "../define.v"

module mux4x1(in_00, in_01, in_10, in_11, slct, out);

	parameter datawidth = 1;

	input[datawidth-1:0]	in_00;
	input[datawidth-1:0]	in_01;
	input[datawidth-1:0]	in_10;
	input[datawidth-1:0]	in_11;
	input[1:0]				slct;
	output[datawidth-1:0]	out;

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