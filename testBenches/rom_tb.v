`include "../define.v"
`include "rom.v"
module rom_tb;
	reg 						rst;
	reg 						ce;
	reg[`InstAddrWidth-1:0]		addr;
	wire[`InstDataWidth-1:0]	data;

	rom #(.InstMemNum(32)) test_rom(
		.rst(rst),
		.ce(ce),
		.addr(addr),
		.inst(data)
	);

	reg[5:0] i;
	initial begin : rom_test
		$dumpfile("vcd/rom_tb.vcd");
		$dumpvars;
		$readmemh("testData/arithmetic.data", test_rom.rom_data, 0, 20);
		$display("time\taddr\tinst");
		rst = ~`RstEnable;

		for (i = 0; i < 21; i = i + 1) begin
			#1 ce = `ChipEnable;
			addr = i << 2;
			#1 $display("%2d\t%d\t%h", $time, addr, data);
			ce = ~`ChipEnable;
		end
		rst = `RstEnable;
		#1 $display("==============================================================");
		rst = ~`RstEnable;
		for (i = 0; i < 21; i = i + 1) begin
			#1 ce = `ChipEnable;
			addr = i << 2;
			#1 $display("%2d\t%d\t%32b", $time, addr, data);
			ce = ~`ChipEnable;
		end
		$finish;
	end
endmodule