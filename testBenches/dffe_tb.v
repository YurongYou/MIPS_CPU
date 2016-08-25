`include "../define.v"
`include "../utilities/dffe.v"
`define WIDE 4
module dffe_tb;
	reg[`WIDE-1:0] data_in;
	wire[`WIDE-1:0] data_out;
	reg clk, rst, hold;

	dffe #(.data_width(`WIDE)) dffe1(.clk(clk),
		.rst(rst),
		.hold(hold),
		.data_in(data_in),
		.data_out(data_out));

	initial begin
		clk = 1;
		forever #1 clk = ~clk;
	end

	initial begin
		$dumpfile("vcd/dffe.vcd");
		$dumpvars;
		hold = 0;
		data_in = 7;
		#5 data_in = 3;
		#5 $finish;
	end
endmodule