`include "../define.v"
`define MemoryDataNum 2048
module memory (
	input							rst,
	input							ce,
	input[`MemDataWidth-1:0]		data_i,
	input[`MemAddrWidth-1:0]		addr_i,
	input							we,
	input[`ByteSlctWidth-1:0]		byte_slct,

	output reg[`MemDataWidth-1:0]	data_o
);

	reg[`MemDataWidth-1:0]		mem_data[`MemoryDataNum-1:0];

	wire[7:0]					mem_byte_0;
	wire[7:0]					mem_byte_1;
	wire[7:0]					mem_byte_2;
	wire[7:0]					mem_byte_3;
	wire[`MemDataWidth-1:0]		data_temp;

	assign mem_byte_0 = (byte_slct[0] == 1'b1) ? data_i[31:24] : mem_data[addr_i][31:24];
	assign mem_byte_1 = (byte_slct[1] == 1'b1) ? data_i[23:16] : mem_data[addr_i][23:16];
	assign mem_byte_3 = (byte_slct[2] == 1'b1) ? data_i[15:8] : mem_data[addr_i][15:8];
	assign mem_byte_4 = (byte_slct[3] == 1'b1) ? data_i[7:0] : mem_data[addr_i][7:0];
	assign data_temp  = {mem_byte_0, mem_byte_1, mem_byte_2, mem_byte_3};

	// reset
	always @(*) begin : proc_reset
		integer i;
		if (rst == `RstEnable) begin
			for (i = 0; i < `MemoryDataNum; i = i + 1)
				mem_data[i] <= `ZeroWord;
		end
	end

	// write operation
	always @ (*) begin
		if (rst == ~`RstEnable && we == `WriteEnable)
			mem_data[addr_i >> 2] <= data_temp;
	end

	// read operation
	always @ (*) begin
		if (rst == ~`RstEnable && ce == `ChipEnable)
			data_o <= mem_data[addr_i >> 2];
		else
			data_o <= `ZeroWord;
	end
endmodule