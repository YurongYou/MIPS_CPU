module EX_MEM (clk, rst, is_hold, target_EX, data_out_EX, we_hi_EX, we_lo_EX, hi_EX, lo_EX, rdata_2_EX, WriteReg_EX, MemOrAlu_EX, WriteMem_EX, target_MEM, data_in_MEM, we_hi_MEM, we_lo_MEM, hi_MEM, lo_MEM, rdata_2_MEM, WriteReg_MEM, MemOrAlu_MEM, WriteMem_MEM);

	input clk;
	input rst;
	input is_hold;

	input[`RegAddrWidth-1:0]	target_EX;
	input[`RegDataWidth-1:0]	data_out_EX;
	input						we_hi_EX;
	input						we_lo_EX;
	input[`RegDataWidth-1:0]	hi_EX;
	input[`RegDataWidth-1:0]	lo_EX;
	input[`RegDataWidth-1:0]	rdata_2_EX;
	input						WriteReg_EX;
	input						MemOrAlu_EX;
	input						WriteMem_EX;

	output[`RegAddrWidth-1:0]	target_MEM;
	output[`RegDataWidth-1:0]	data_in_MEM;
	output						we_hi_MEM;
	output						we_lo_MEM;
	output[`RegDataWidth-1:0]	hi_MEM;
	output[`RegDataWidth-1:0]	lo_MEM;
	output[`RegDataWidth-1:0]	rdata_2_MEM;
	output						WriteReg_MEM;
	output						MemOrAlu_MEM;
	output						WriteMem_MEM;

	dffe #(.data_width(`RegAddrWidth)) target_holder(clk, rst, is_hold, target_EX, target_MEM);
	dffe #(.data_width(`RegDataWidth)) data_holder(clk, rst, data_out_EX, data_in_MEM);
	dffe we_hi_holder(clk, rst, we_hi_EX, we_hi_MEM);
	dffe we_lo_holder(clk, rst, we_lo_EX, we_lo_MEM);
	dffe #(.data_width(`RegDataWidth)) hi_holder(clk, rst, hi_EX, hi_MEM);
	dffe #(.data_width(`RegDataWidth)) lo_holder(clk, rst, lo_EX, lo_MEM);
	dffe #(.data_width(`RegDataWidth)) rdata_2_holder(clk, rst, rdata_2_EX, rdata_2_MEM);
	dffe WriteReg_holder(clk, rst, WriteReg_EX, WriteReg_MEM);
	dffe MemOrAlu_holder(clk, rst, MemOrAlu_EX, MemOrAlu_MEM);
	dffe WriteMem_holder(clk, rst, WriteMem_EX, WriteMem_MEM);
endmodule