`include "../define.v"
`include "../hilo_reg.v"

module hilo_reg_tb;
	reg clk, rst;

	reg we_hi;
	reg[`RegDataWidth-1:0] hi_data_in;

	reg we_lo;
	reg[`RegDataWidth-1:0] lo_data_in;

	wire reg[`RegDataWidth-1:0] hi_data_out;
	wire reg[`RegDataWidth-1:0] lo_data_out;

	initial begin
		clk = 1;
		forever #1 clk = ~clk;
	end

	hilo_reg hilo(clk, rst, we_hi, hi_data_in, we_lo, lo_data_in, hi_data_out, lo_data_out);
	initial begin: test
		$dumpfile("vcd/hilo_reg_tb.vcd");
		$dumpvars;
		rst = ~`RstEnable;
		we_hi = `WriteEnable;
		hi_data_in = 1 << 10;
		#2.5 we_hi = ~`WriteEnable;
		we_lo = `WriteEnable;
		lo_data_in = 1 << 20;
		#2.5 we_lo = ~`WriteEnable;
		$display("the hi is%32b", hi_data_out);
		$display("the lo is%32b", lo_data_out);
		#1 $finish;
	end
endmodule