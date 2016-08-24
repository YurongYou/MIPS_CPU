`include "../define.v"
`include "../utilities/mux2x1.v"
`define WIDE 4
module mux2x1_tb;
	reg[`WIDE-1:0] in_0;
	reg[`WIDE-1:0] in_1;
	reg slct;
	wire[`WIDE-1:0] out;
	mux2x1 #(`WIDE) mux_1(in_0, in_1, slct, out);

	initial begin
		$dumpfile("mux2x1.vcd");
		$dumpvars;
		in_0 = 10;
		in_1 = 15;
		slct = 0;
		#1 $display("%4b", out);
		#1 slct = 1;
		#1 $display("%4b", out);
	end
endmodule // mux2x1_tb