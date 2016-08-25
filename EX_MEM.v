module EX_MEM (
	input clk,
	input rst,
	input is_hold,

	input[`RegAddrWidth-1:0]	target_EX,
	input[`RegDataWidth-1:0]	data_out_EX,
	input						we_hi_EX,
	input						we_lo_EX,
	input[`RegDataWidth-1:0]	hi_EX,
	input[`RegDataWidth-1:0]	lo_EX,
	input[`RegAddrWidth-1:0]	raddr_2_EX,
	input[`RegDataWidth-1:0]	rdata_2_EX,
	input						WriteReg_EX,
	input						MemOrAlu_EX,
	input						WriteMem_EX,
	input						ReadMem_EX,
	input[`ByteSlctWidth-1:0]		byte_slct_EX,

	output[`RegAddrWidth-1:0]	target_MEM,
	output[`RegDataWidth-1:0]	data_from_ALU_MEM,
	output						we_hi_MEM,
	output						we_lo_MEM,
	output[`RegDataWidth-1:0]	hi_MEM,
	output[`RegDataWidth-1:0]	lo_MEM,
	output[`RegDataWidth-1:0]	rdata_2_MEM,
	output[`RegAddrWidth-1:0]	raddr_2_MEM,
	output						WriteReg_MEM,
	output						MemOrAlu_MEM,
	output						WriteMem_MEM,
	output						ReadMem_MEM,
	output[`ByteSlctWidth-1:0]	byte_slct_MEM
);

	dffe #(.data_width(`RegAddrWidth)) target_holder(clk, rst, is_hold, target_EX, target_MEM);
	dffe #(.data_width(`RegDataWidth)) data_holder(clk, rst, is_hold, data_out_EX, data_from_ALU_MEM);
	dffe we_hi_holder(clk, rst, is_hold, we_hi_EX, we_hi_MEM);
	dffe we_lo_holder(clk, rst, is_hold, we_lo_EX, we_lo_MEM);
	dffe #(.data_width(`RegDataWidth)) hi_holder(clk, rst, is_hold, hi_EX, hi_MEM);
	dffe #(.data_width(`RegDataWidth)) lo_holder(clk, rst, is_hold, lo_EX, lo_MEM);
	dffe #(.data_width(`RegAddrWidth)) raddr_2_holder(clk, rst, is_hold, raddr_2_EX, raddr_2_MEM);
	dffe #(.data_width(`RegDataWidth)) rdata_2_holder(clk, rst, is_hold, rdata_2_EX, rdata_2_MEM);
	dffe WriteReg_holder(clk, rst, is_hold, WriteReg_EX, WriteReg_MEM);
	dffe MemOrAlu_holder(clk, rst, is_hold, MemOrAlu_EX, MemOrAlu_MEM);
	dffe WriteMem_holder(clk, rst, is_hold, WriteMem_EX, WriteMem_MEM);
	dffe ReadMem_holder(clk, rst, is_hold, ReadMem_EX, ReadMem_MEM);
	dffe #(.data_width(`ByteSlctWidth)) byte_slct_holder(clk, rst, is_hold, byte_slct_EX, byte_slct_MEM);
endmodule