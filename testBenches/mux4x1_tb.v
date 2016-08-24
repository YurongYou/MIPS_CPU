`include "../define.v"
`include "../utilities/mux4x1.v"
`define WIDE 4
module mux2x1_tb;
	reg[`WIDE-1:0] in_00;
	reg[`WIDE-1:0] in_01;
	reg[`WIDE-1:0] in_10;
	reg[`WIDE-1:0] in_11;
	reg[1:0] slct;
	wire[`WIDE-1:0] out;
	mux4x1 #(`WIDE) mux_1(in_00, in_01, in_10, in_11, slct, out);

	initial begin
		$dumpfile("mux4x1.vcd");
		$dumpvars;
		in_00 = 2;
		in_01 = 4;
		in_10 = 6;
		in_11 = 8;
		slct = 0;
		#1 $display("%4b", out);
		#1 slct = 1;
		#1 $display("%4b", out);
		#1 slct = 2;
		#1 $display("%4b", out);
		#1 slct = 3;
		#1 $display("%4b", out);
	end
endmodule // mux2x1_tb