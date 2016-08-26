`ifndef PIPELINE_DEF
`include "define.v"
`endif
module ID (

	input 							rst,
	input[`InstAddrWidth-1:0] 		pc_plus4,
	input[`InstDataWidth-1:0] 		inst,

	output[`RegAddrWidth-1:0] 		reg1_addr,
	output[`RegAddrWidth-1:0] 		reg2_addr,

	output 							WriteReg,
	output							MemOrAlu,
	output							WriteMem,
	output							ReadMem,
	output[1:0]						AluType,
	output[1:0]						AluOp,
	output							AluSrcA,
	output							AluSrcB,
	output							RegDes,
	output 							ImmSigned,
	output 							is_jal,

	output[`RegAddrWidth-1:0] 		rt,
	output[`RegAddrWidth-1:0] 		rd,
	output[`RegDataWidth-1:0]	  	imm_signed,
	output[`RegDataWidth-1:0]	  	imm_unsigned,
	output[`RegDataWidth-1:0]	  	shamt,
	output[`ByteSlctWidth-1:0]		byte_slct,
	output 							mfhi_lo
);
	decoder decode(
		.rst(rst),
		.inst(inst),

		.WriteReg(WriteReg),
		.MemOrAlu(MemOrAlu),
		.WriteMem(WriteMem),
		.ReadMem(ReadMem),
		.AluType(AluType),
		.AluOp(AluOp),
		.AluSrcA(AluSrcA),
		.AluSrcB(AluSrcB),
		.RegDes(RegDes),
		.ImmSigned(ImmSigned),
		.byte_slct(byte_slct),
		.is_jal(is_jal),
		.mfhi_lo(mfhi_lo),
	);

	assign reg1_addr = inst[`RsBus];
	assign reg2_addr = inst[`RtBus];
	assign rt 		 = inst[`RtBus];
	assign rd 		 = inst[`RdBus];

	assign imm_signed = {{16{inst[15]}}, inst[`ImmBus]};
	assign imm_unsigned = {16'b0, inst[`ImmBus]};
	assign shamt = {27'b0, inst[`SaBus]};
endmodule