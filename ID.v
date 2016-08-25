`ifndef PIPELINE_DEF
`include "define.v"
`endif
module ID (rst, pc_plus4, inst, reg1_addr, reg2_addr, WriteReg, MemOrAlu, WriteMem, AluType, AluOp, AluSrcA, AluSrcB, RegDes, ImmSigned, rt, rd, imm_signed, imm_unsigned, shamt);

	input 							rst;
	input[`InstAddrWidth-1:0] 		pc_plus4;
	input[`InstDataWidth-1:0] 		inst;

	output[`RegAddrWidth-1:0] 		reg1_addr;
	output[`RegAddrWidth-1:0] 		reg2_addr;

	output 							WriteReg;
	output							MemOrAlu;
	output							WriteMem;
	output[1:0]						AluType;
	output[1:0]						AluOp;
	output							AluSrcA;
	output							AluSrcB;
	output							RegDes;
	output 							ImmSigned;

	output [`RegAddrWidth-1:0] 		rt;
	output [`RegAddrWidth-1:0] 		rd;
	output [`RegDataWidth-1:0]	  	imm_signed;
	output [`RegDataWidth-1:0]	  	imm_unsigned;
	output [`RegDataWidth-1:0]	  	shamt;

	decoder decode(rst, inst, WriteReg, MemOrAlu, WriteMem, AluType, AluOp, AluSrcA, AluSrcB, RegDes, ImmSigned);

	assign reg1_addr = inst[`RsBus];
	assign reg2_addr = inst[`RtBus];
	assign rt 		 = inst[`RtBus];
	assign rd 		 = inst[`RdBus];

	assign imm_signed = {{16{inst[15]}}, inst[`ImmBus]};
	assign imm_unsigned = {16'b0, inst[`ImmBus]};
	assign shamt = {27'b0, inst[`SaBus]};
endmodule