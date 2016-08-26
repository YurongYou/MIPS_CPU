module EX(
	input rst,

	input[`RegDataWidth-1:0]		shamt,
	input[`ALUTypeWidth-1:0]		AluType_EX,
	input[`ALUOpWidth-1:0]			AluOp_EX,
	input							AluSrcA_EX,
	input							AluSrcB_EX,
	input							RegDes_EX,
	input 							ImmSigned_EX,
	input							is_jal_EX,
	input[`RegAddrWidth-1:0] 		rt_EX,
	input[`RegAddrWidth-1:0] 		rd_EX,
	input[`RegDataWidth-1:0]	  	imm_signed_EX,
	input[`RegDataWidth-1:0]	  	imm_unsigned_EX,

	input[`RegDataWidth-1:0]		hi,
	input[`RegDataWidth-1:0]		lo,
	input[`RegDataWidth-1:0]		rdata_1,
	input[`RegDataWidth-1:0]		rdata_2,
	input[`InstAddrWidth-1:0]	 	pc_plus4_EX,
	// forwarded data
	input[`RegDataWidth-1:0]		data_out_MEM,
	input[`RegDataWidth-1:0]		data_out_WB,
	input[`RegDataWidth-1:0]		hi_MEM,
	input[`RegDataWidth-1:0]		hi_WB,
	input[`RegDataWidth-1:0]		lo_MEM,
	input[`RegDataWidth-1:0]		lo_WB,

	// forward info
	input[1:0]						FWA,
	input[1:0]						FWB,
	input[1:0]						FWhi,
	input[1:0]						FWlo,

	output[`RegAddrWidth-1:0]		target_EX,
	output							is_Overflow,
	output[`RegDataWidth-1:0]		data_out_EX,
	output							we_hi,
	output							we_lo,
	output[`RegDataWidth-1:0]		hi_EX,
	output[`RegDataWidth-1:0]		lo_EX,
	output[`RegDataWidth-1:0]		rdata_2_EX
);

	wire[`RegDataWidth-1:0]			rdata_1_EX;
	wire[`RegDataWidth-1:0]			lo_in;
	wire[`RegDataWidth-1:0]			hi_in;
	wire[`RegDataWidth-1:0] 		imm;
	wire[`RegDataWidth-1:0] 		srcA;
	wire[`RegDataWidth-1:0] 		srcB;
	wire[`RegDataWidth-1:0]			lo_temp;
	wire[`RegDataWidth-1:0]			hi_temp;

	mux2x1 #(.data_width(`RegDataWidth)) imm_mux(
		.in_0(imm_unsigned_EX),
		.in_1(imm_signed_EX),
		.slct(ImmSigned_EX),
		.out(imm)
	);

	// Forwarding
	mux4x1 #(.data_width(`RegDataWidth)) forwardA(
		.in_00(rdata_1),
		.in_01(data_out_MEM),
		.in_10(data_out_WB),
		.slct(FWA),
		.out(rdata_1_EX)
	);

	mux4x1 #(.data_width(`RegDataWidth)) forwardB(
		.in_00(rdata_2),
		.in_01(data_out_MEM),
		.in_10(data_out_WB),
		.slct(FWB),
		.out(rdata_2_EX)
	);

	mux4x1 #(.data_width(`RegDataWidth)) forwardHi(
		.in_00(hi),
		.in_01(hi_MEM),
		.in_10(hi_WB),
		.slct(FWhi),
		.out(hi_in)
	);

	mux4x1 #(.data_width(`RegDataWidth)) forwardLo(
		.in_00(lo),
		.in_01(lo_MEM),
		.in_10(lo_WB),
		.slct(FWlo),
		.out(lo_in)
	);

	mux2x1 #(.data_width(`RegDataWidth)) srcA_mux(
		.in_0(shamt),
		.in_1(rdata_1_EX),
		.slct(AluSrcA_EX),
		.out(srcA)
	);
	mux2x1 #(.data_width(`RegDataWidth)) srcB_mux(
		.in_0(rdata_2_EX),
		.in_1(imm),
		.slct(AluSrcB_EX),
		.out(srcB)
	);

	wire[`RegAddrWidth-1:0]		target_temp;
	wire[`RegAddrWidth-1:0]		constant_31;
	assign constant_31 = 31;

	mux2x1 #(.data_width(`RegAddrWidth)) target_temp_mux(
		.in_0(rt_EX),
		.in_1(rd_EX),
		.slct(RegDes_EX),
		.out(target_temp)
	);

	mux2x1 #(.data_width(`RegAddrWidth)) target_mux(
		.in_0(target_temp),
		.in_1(constant_31),
		.slct(is_jal_EX),
		.out(target_EX)
	);

	wire[`RegDataWidth-1:0]	temp_data_out_EX;
	ALU arith_logic_unit(
		.rst(rst),
		.srcA(srcA),
		.srcB(srcB),
		.AluType(AluType_EX),
		.AluOp(AluOp_EX),
		.hi_in(hi_in),
		.lo_in(lo_in),
		.is_Overflow(is_Overflow),
		.data_out(temp_data_out_EX),
		.we_hi(we_hi),
		.we_lo(we_lo),
		.hi_out(hi_temp),
		.lo_out(lo_temp)
	);

	mux2x1 #(.data_width(`RegDataWidth)) data_out_mix(
		.in_0(temp_data_out_EX),
		.in_1(pc_plus4_EX),
		.slct(is_jal_EX),
		.out(data_out_EX)
	);

	mux2x1 #(.data_width(`RegDataWidth)) hi_mux(
		.in_0(hi),
		.in_1(hi_temp),
		.slct(we_hi),
		.out(hi_EX)
	);

	mux2x1 #(.data_width(`RegDataWidth)) lo_mux(
		.in_0(lo),
		.in_1(lo_temp),
		.slct(we_lo),
		.out(lo_EX)
	);

endmodule