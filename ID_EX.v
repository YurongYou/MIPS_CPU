`ifndef PIPELINE_DEF
`include "../define.v"
`endif
module ID_EX (clk, rst, is_hold, rdata_1_ID, rdata_2_ID, raddr_1_ID, raddr_2_ID, shamt_ID, WriteReg_ID, MemOrAlu_ID, WriteMem_ID, AluType_ID, AluOp_ID, AluSrcA_ID, AluSrcB_ID, RegDes_ID, ImmSigned_ID, rt_ID, rd_ID, imm_signed_ID, imm_unsigned_ID, hi_ID, lo_ID, rdata_1_EX, rdata_2_EX, raddr_1_EX, raddr_2_EX, shamt_EX, WriteReg_EX, MemOrAlu_EX, WriteMem_EX, AluType_EX, AluOp_EX, AluSrcA_EX, AluSrcB_EX, RegDes_EX, ImmSigned_EX, rt_EX, rd_EX, imm_signed_EX, imm_unsigned_EX, hi_EX, lo_EX);

	input clk;
	input rst;
	input is_hold;

	// info input
	input[`RegDataWidth-1:0]		rdata_1_ID;
	input[`RegDataWidth-1:0]		rdata_2_ID;
	input[`RegAddrWidth-1:0]		raddr_1_ID;
	input[`RegAddrWidth-1:0]		raddr_2_ID;
	input[`RegDataWidth-1:0]		shamt_ID;
	input 							WriteReg_ID;
	input							MemOrAlu_ID;
	input							WriteMem_ID;
	input							ReadMem_ID;
	input[1:0]						AluType_ID;
	input[1:0]						AluOp_ID;
	input							AluSrcA_ID;
	input							AluSrcB_ID;
	input							RegDes_ID;
	input 							ImmSigned_ID;
	input[`RegAddrWidth-1:0] 		rt_ID;
	input[`RegAddrWidth-1:0] 		rd_ID;
	input[`RegDataWidth-1:0]	  	imm_signed_ID;
	input[`RegDataWidth-1:0]	  	imm_unsigned_ID;
	input[`RegDataWidth-1:0]		hi_ID;
	input[`RegDataWidth-1:0]		lo_ID;

	// info output
	output[`RegDataWidth-1:0]		rdata_1_EX;
	output[`RegDataWidth-1:0]		rdata_2_EX;
	output[`RegAddrWidth-1:0]		raddr_1_EX;
	output[`RegAddrWidth-1:0]		raddr_2_EX;
	output[`RegDataWidth-1:0]		shamt_EX;
	output 							WriteReg_EX;
	output							MemOrAlu_EX;
	output							WriteMem_EX;
	output							ReadMem_EX;
	output[1:0]						AluType_EX;
	output[1:0]						AluOp_EX;
	output							AluSrcA_EX;
	output							AluSrcB_EX;
	output							RegDes_EX;
	output 							ImmSigned_EX;
	output[`RegAddrWidth-1:0] 		rt_EX;
	output[`RegAddrWidth-1:0] 		rd_EX;
	output[`RegDataWidth-1:0]	  	imm_signed_EX;
	output[`RegDataWidth-1:0]	  	imm_unsigned_EX;
	output[`RegDataWidth-1:0]		hi_EX;
	output[`RegDataWidth-1:0]		lo_EX;

	dffe #(.data_width(`RegDataWidth)) rdata_1_holder(clk, rst, is_hold, rdata_1_ID, rdata_1_EX);
	dffe #(.data_width(`RegDataWidth)) rdata_2_holder(clk, rst, is_hold, rdata_2_ID, rdata_2_EX);

	dffe #(.data_width(`RegAddrWidth)) raddr_1_holder(clk, rst, is_hold, raddr_1_ID, raddr_1_EX);
	dffe #(.data_width(`RegAddrWidth)) raddr_2_holder(clk, rst, is_hold, raddr_2_ID, raddr_2_EX);

	dffe #(.data_width(`RegDataWidth)) shamt_holder(clk, rst, is_hold, shamt_ID, shamt_EX);
	dffe WriteReg_holder(clk, rst, is_hold, WriteMem_ID, WriteMem_EX);
	dffe MemOrAlu_holder(clk, rst, is_hold, MemOrAlu_ID, MemOrAlu_EX);
	dffe WriteMem_holder(clk, rst, is_hold, WriteMem_ID, WriteMem_EX);
	dffe ReadMem_holder(clk, rst, is_hold, ReadMem_ID, ReadMem_EX);
	dffe #(.data_width(2)) AluType_holder(clk, rst, is_hold, AluType_ID, AluType_EX);
	dffe #(.data_width(2)) AluOp_holder(clk, rst, is_hold, AluOp_ID, AluOp_EX);
	dffe AluSrcA_holder(clk, rst, is_hold, AluSrcA_ID, AluSrcA_EX);
	dffe AluSrcB_holder(clk, rst, is_hold, AluSrcB_ID, AluSrcB_EX);
	dffe RegDes_holder(clk, rst, is_hold, RegDes_ID, RegDes_EX);
	dffe ImmSigned_holder(clk, rst, is_hold, ImmSigned_ID, ImmSigned_EX);
	dffe #(.data_width(`RegAddrWidth)) rt_holder(clk, rst, is_hold, rt_ID, rt_EX);
	dffe #(.data_width(`RegAddrWidth)) rd_holder(clk, rst, is_hold, rd_ID, rd_EX);
	dffe #(.data_width(`RegDataWidth)) imm_signed_holder(clk, rst, is_hold, imm_signed_ID, imm_signed_EX);
	dffe #(.data_width(`RegDataWidth)) imm_unsigned_holder(clk, rst, is_hold, imm_unsigned_ID, imm_unsigned_EX);
	dffe #(.data_width(`RegDataWidth)) hi_holder(clk, rst, is_hold, hi_ID, hi_EX);
	dffe #(.data_width(`RegDataWidth)) lo_holder(clk, rst, is_hold, lo_ID, lo_EX);

endmodule