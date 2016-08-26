// `include "define.v"
// `include "regfile.v"
// `include "hilo_reg.v"
// `include "BranchControl.v"
// `include "HazardControl.v"
// `include "ForwardControl.v"
// `include "IF.v"
// `include "IF_ID.v"
// `include "ID.v"
// `include "ID_EX.v"
// `include "EX.v"
// `include "ALU.v"
// `include "decoder.v"
// `include "EX_MEM.v"
// `include "MEM.v"
// `include "RM_ctrl.v"
// `include "WM_ctrl.v"
// `include "MEM_WB.v"
// `include "utilities/dffe.v"
// `include "utilities/mux2x1.v"
// `include "utilities/mux4x1.v"
module pipeline_CPU (
	input 						clk,
	input 						rst,

	input[`RegDataWidth-1:0]	data_from_mem,
	output[`MemAddrWidth-1:0]	mem_addr,
	output[3:0]					mem_byte_slct,
	output[`RegDataWidth-1:0]	data_to_write_mem,
	output						mem_we,
	output						mem_re,

	input[`InstDataWidth-1:0] 	inst_from_rom,
	output[`InstAddrWidth-1:0] 	rom_addr,
	output						rom_ce
	);

	supply1 					vcc;
	supply0 					gnd;

	// Forwarding wire
	wire[1:0]					FWA;
	wire[1:0]					FWB;
	wire[1:0]					FWhi;
	wire[1:0]					FWlo;
	wire						FWLS;
	wire[1:0]					FW_br_A;
	wire[1:0]					FW_br_B;

	// branch control wire
	wire[`InstAddrWidth-1:0]	branch_address;
	wire 						is_branch;
	wire 						is_rst_IF_ID;

	// Hazard Control wire
	wire 						is_hold_IF;
	wire 						is_hold_IF_ID;
	wire 						is_zeros_ID_EX;

	wire[`InstAddrWidth-1:0] 	pc_plus4_IF;

	wire[`InstDataWidth-1:0] 	inst_ID;
	wire[`InstAddrWidth-1:0] 	pc_plus4_ID;

	IF inst_fetch(.clk      (clk),
		.rst      (rst),
		.is_hold  (is_hold_IF),
		.is_branch(is_branch),
		.branch_address(branch_address),
		.ce(rom_ce),
		.pc(rom_addr),
		.pc_plus4(pc_plus4_IF)
	);


	wire IF_ID_controlor;
	mux2x1 IF_ID_control(
		.in_0(rst),
		.in_1(vcc),
		.slct(is_rst_IF_ID),
		.out(IF_ID_controlor)
	);

	IF_ID if_id_reg(
		.clk        (clk),
		.rst        (IF_ID_controlor),
		.is_hold    (is_hold_IF_ID),
		.pc_plus4_IF(pc_plus4_IF),
		.inst_IF    (inst_from_rom),
		.pc_plus4_ID(pc_plus4_ID),
		.inst_ID    (inst_ID)
	);


	wire[`RegAddrWidth-1:0]		raddr_1_ID;
	wire[`RegDataWidth-1:0]		rdata_1_ID;
	wire[`RegAddrWidth-1:0]		raddr_2_ID;
	wire[`RegDataWidth-1:0]		rdata_2_ID;
	wire[`RegDataWidth-1:0]		shamt_ID;

	wire 						WriteReg_ID;
	wire						MemOrAlu_ID;
	wire						WriteMem_ID;
	wire 						ReadMem_ID;
	wire[1:0]					AluType_ID;
	wire[1:0]					AluOp_ID;
	wire						AluSrcA_ID;
	wire						AluSrcB_ID;
	wire						RegDes_ID;
	wire 						ImmSigned_ID;
	wire 						is_jal_ID;
	wire 						mfhi_lo_ID;
	wire[`RegAddrWidth-1:0] 	rt_ID;
	wire[`RegAddrWidth-1:0] 	rd_ID;
	wire[`RegDataWidth-1:0]	  	imm_signed_ID;
	wire[`RegDataWidth-1:0]	  	imm_unsigned_ID;
	wire[`ByteSlctWidth-1:0]	byte_slct_ID;

	ID inst_decode(
		.rst(rst),
		.pc_plus4(pc_plus4_ID),
		.inst(inst_ID),

		.reg1_addr(raddr_1_ID),
		.reg2_addr(raddr_2_ID),
		.WriteReg(WriteReg_ID),
		.MemOrAlu(MemOrAlu_ID),
		.WriteMem(WriteMem_ID),
		.ReadMem(ReadMem_ID),
		.AluType(AluType_ID),
		.AluOp(AluOp_ID),
		.AluSrcA(AluSrcA_ID),
		.AluSrcB(AluSrcB_ID),
		.RegDes(RegDes_ID),
		.ImmSigned(ImmSigned_ID),
		.rt(rt_ID),
		.rd(rd_ID),
		.imm_signed(imm_signed_ID),
		.imm_unsigned(imm_unsigned_ID),
		.shamt(shamt_ID),
		.byte_slct(byte_slct_ID),
		.is_jal(is_jal_ID),
		.mfhi_lo(mfhi_lo_ID)
	);


	wire[`RegAddrWidth-1:0]		reg_write_addr;
	wire[`RegDataWidth-1:0]		reg_write_data;
	wire						reg_we;

	wire 						we_hi;
	wire[`RegDataWidth-1:0] 	hi_data_in;

	wire 						we_lo;
	wire[`RegDataWidth-1:0] 	lo_data_in;

	wire[`RegDataWidth-1:0] 	hi_data_out_ID;
	wire[`RegDataWidth-1:0] 	lo_data_out_ID;
	wire[`RegDataWidth-1:0] 	hi_data_to_EX;
	wire[`RegDataWidth-1:0] 	lo_data_to_EX;

	// force read regfile
	regfile regs(
		.clk(clk),
		.rst(rst),
		.waddr(reg_write_addr),
		.wdata(reg_write_data),
		.we(reg_we),
		.re1(vcc),
		.raddr_1(raddr_1_ID),
		.rdata_1(rdata_1_ID),
		.re2(vcc),
		.raddr_2(raddr_2_ID),
		.rdata_2(rdata_2_ID)
	);

	hilo_reg hilo_regs(
		.clk(clk),
		.rst(rst),
		.we_hi(we_hi),
		.hi_data_in(hi_data_in),
		.we_lo(we_lo),
		.lo_data_in(lo_data_in),
		.hi_data_out(hi_data_out_ID),
		.lo_data_out(lo_data_out_ID)
	);

	wire 						WriteReg_EX;
	wire						MemOrAlu_EX;
	wire						WriteMem_EX;
	wire 						ReadMem_EX;
	wire[1:0]					AluType_EX;
	wire[1:0]					AluOp_EX;
	wire						AluSrcA_EX;
	wire						AluSrcB_EX;
	wire						RegDes_EX;
	wire 						ImmSigned_EX;
	wire 						is_jal_EX;
	wire 						mfhi_lo_EX;
	wire[`RegAddrWidth-1:0] 	rt_EX;
	wire[`RegAddrWidth-1:0] 	rd_EX;
	wire[`RegDataWidth-1:0]	  	imm_signed_EX;
	wire[`RegDataWidth-1:0]	  	imm_unsigned_EX;
	wire[`ByteSlctWidth-1:0]	byte_slct_EX;
	wire[`RegDataWidth-1:0]		rdata_1_EX;
	wire[`RegDataWidth-1:0]		rdata_2_EX;
	wire[`RegAddrWidth-1:0]		raddr_1_EX;
	wire[`RegAddrWidth-1:0]		raddr_2_EX;
	wire[`RegDataWidth-1:0]		shamt_EX;
	wire[`InstAddrWidth-1:0] 	pc_plus4_EX;

	wire ID_EX_controlor;
	mux2x1 ID_EX_control(
		.in_0(rst),
		.in_1(vcc),
		.slct(is_zeros_ID_EX),
		.out(ID_EX_controlor)
	);

	ID_EX id_ex_reg(
		.clk(clk),
		.rst(ID_EX_controlor),
		.is_hold(gnd),
		.rdata_1_ID(rdata_1_ID),
		.rdata_2_ID(rdata_2_ID),
		.raddr_1_ID(raddr_1_ID),
		.raddr_2_ID(raddr_2_ID),
		.shamt_ID(shamt_ID),
		.WriteReg_ID(WriteReg_ID),
		.MemOrAlu_ID(MemOrAlu_ID),
		.WriteMem_ID(WriteMem_ID),
		.ReadMem_ID(ReadMem_ID),
		.AluType_ID(AluType_ID),
		.AluOp_ID(AluOp_ID),
		.AluSrcA_ID(AluSrcA_ID),
		.AluSrcB_ID(AluSrcB_ID),
		.RegDes_ID(RegDes_ID),
		.ImmSigned_ID(ImmSigned_ID),
		.is_jal_ID   (is_jal_ID),
		.mfhi_lo_ID(mfhi_lo_ID)
		.rt_ID(rt_ID),
		.rd_ID(rd_ID),
		.imm_signed_ID(imm_signed_ID),
		.imm_unsigned_ID(imm_unsigned_ID),
		.byte_slct_ID(byte_slct_ID),
		.hi_ID(hi_data_out_ID),
		.lo_ID(lo_data_out_ID),
		.pc_plus4_ID(pc_plus4_ID),

		.rdata_1_EX(rdata_1_EX),
		.rdata_2_EX(rdata_2_EX),
		.raddr_1_EX(raddr_1_EX),
		.raddr_2_EX(raddr_2_EX),
		.shamt_EX(shamt_EX),
		.WriteReg_EX(WriteReg_EX),
		.MemOrAlu_EX(MemOrAlu_EX),
		.ReadMem_EX(ReadMem_EX),
		.WriteMem_EX(WriteMem_EX),
		.AluType_EX(AluType_EX),
		.AluOp_EX(AluOp_EX),
		.AluSrcA_EX(AluSrcA_EX),
		.AluSrcB_EX(AluSrcB_EX),
		.RegDes_EX(RegDes_EX),
		.ImmSigned_EX(ImmSigned_EX),
		.is_jal_EX(is_jal_EX),
		.mfhi_lo_EX(mfhi_lo_EX),
		.rt_EX(rt_EX),
		.rd_EX(rd_EX),
		.imm_signed_EX(imm_signed_EX),
		.imm_unsigned_EX(imm_unsigned_EX),
		.byte_slct_EX(byte_slct_EX),
		.hi_EX(hi_data_to_EX),
		.lo_EX(lo_data_to_EX),
		.pc_plus4_EX(pc_plus4_EX)
	);

	wire[`RegAddrWidth-1:0]		target_EX;
	wire						is_Overflow;
	wire[`RegDataWidth-1:0]		data_out_EX;
	wire						we_hi_EX;
	wire						we_lo_EX;
	wire[`RegDataWidth-1:0]		hi_EX;
	wire[`RegDataWidth-1:0]		lo_EX;
	wire[`RegDataWidth-1:0]		rdata_2_EX_out;


	wire[`RegDataWidth-1:0]		hi_MEM;
	wire[`RegDataWidth-1:0]		lo_MEM;

	wire[`RegDataWidth-1:0]		data_from_ALU_MEM;

	EX execution(
		.rst(rst),
		.shamt(shamt_EX),
		.AluType_EX(AluType_EX),
		.AluOp_EX(AluOp_EX),
		.AluSrcA_EX(AluSrcA_EX),
		.AluSrcB_EX(AluSrcB_EX),
		.RegDes_EX(RegDes_EX),
		.ImmSigned_EX(ImmSigned_EX),
		.is_jal_EX   (is_jal_EX),
		.mfhi_lo_EX  (mfhi_lo_EX),
		.rt_EX(rt_EX),
		.rd_EX(rd_EX),
		.imm_signed_EX(imm_signed_EX),
		.imm_unsigned_EX(imm_unsigned_EX),
		.hi(hi_data_to_EX),
		.lo(lo_data_to_EX),
		.rdata_1(rdata_1_EX),
		.rdata_2(rdata_2_EX),
		.pc_plus4_EX(pc_plus4_EX),
		// forwarding data in
		.data_out_MEM(data_from_ALU_MEM),
		.data_out_WB(reg_write_data),
		.hi_MEM(hi_MEM),
		.hi_WB(hi_data_in),
		.lo_MEM(lo_MEM),
		.lo_WB(lo_data_in),
		.FWA(FWA),
		.FWB(FWB),
		.FWhi(FWhi),
		.FWlo(FWlo),

		.target_EX(target_EX),
		.is_Overflow(is_Overflow),
		.data_out_EX(data_out_EX),
		.rdata_2_EX(rdata_2_EX_out),
		.hi_EX(hi_EX),
		.lo_EX(lo_EX),
		.we_hi(we_hi_EX),
		.we_lo(we_lo_EX)
	);

	wire[`RegAddrWidth-1:0]		target_MEM;

	wire						we_hi_MEM;
	wire						we_lo_MEM;

	wire[`RegDataWidth-1:0]		rdata_2_MEM;
	wire[`RegAddrWidth-1:0]		raddr_2_MEM;
	wire						WriteReg_MEM;
	wire						MemOrAlu_MEM;
	wire						WriteMem_MEM;
	wire						ReadMem_MEM;
	wire[`ByteSlctWidth-1:0]	byte_slct_MEM;

	EX_MEM ex_mem_reg(
		.clk(clk),
		.rst(rst),
		// set gnd temporarily
		.is_hold(gnd),
		.target_EX(target_EX),
		.data_out_EX(data_out_EX),
		.we_hi_EX(we_hi_EX),
		.we_lo_EX(we_lo_EX),
		.hi_EX(hi_EX),
		.lo_EX(lo_EX),
		.raddr_2_EX(raddr_2_EX),
		.rdata_2_EX(rdata_2_EX_out),
		.WriteReg_EX(WriteReg_EX),
		.MemOrAlu_EX(MemOrAlu_EX),
		.WriteMem_EX(WriteMem_EX),
		.ReadMem_EX(ReadMem_EX),
		.byte_slct_EX(byte_slct_EX),

		.target_MEM(target_MEM),
		.data_from_ALU_MEM(data_from_ALU_MEM),
		.we_hi_MEM(we_hi_MEM),
		.we_lo_MEM(we_lo_MEM),
		.hi_MEM(hi_MEM),
		.lo_MEM(lo_MEM),
		.raddr_2_MEM(raddr_2_MEM),
		.rdata_2_MEM(rdata_2_MEM),
		.WriteReg_MEM(WriteReg_MEM),
		.MemOrAlu_MEM(MemOrAlu_MEM),
		.WriteMem_MEM(WriteMem_MEM),
		.ReadMem_MEM(ReadMem_MEM),
		.byte_slct_MEM(byte_slct_MEM)
	);

	wire[`RegDataWidth-1:0]		MEM_data_MEM;
	// memory read/write

	MEM mem(
		.rst(rst),
		.FWLS(FWLS),
		.reg_data_2(rdata_2_MEM),
		.WB_data(reg_write_data),
		.raw_mem_data(data_from_mem),
		.ReadMem(ReadMem_MEM),
		.WriteMem(WriteMem_MEM),
		.byte_slct(byte_slct_MEM),

		.data_to_write_mem(data_to_write_mem),
		.data_to_reg(MEM_data_MEM)
	);

	assign mem_addr 		 = 	data_from_ALU_MEM;
	assign mem_byte_slct 	 = 	byte_slct_MEM;
	assign mem_re 			 = 	ReadMem_MEM;
	assign mem_we 			 = 	WriteMem_MEM;

	wire[`RegDataWidth-1:0]		ALU_data_WB;
	wire[`RegDataWidth-1:0]		MEM_data_WB;

	MEM_WB mem_wb_reg(
		.clk(clk),
		.rst(rst),
		// set gnd temporarily
		.is_hold(gnd),

		.target_MEM(target_MEM),
		.ALU_data_MEM(data_from_ALU_MEM),
		.MEM_data_MEM(MEM_data_MEM),
		.we_hi_MEM(we_hi_MEM),
		.we_lo_MEM(we_lo_MEM),
		.hi_MEM(hi_MEM),
		.lo_MEM(lo_MEM),
		.WriteReg_MEM(WriteReg_MEM),
		.MemOrAlu_MEM(MemOrAlu_MEM),

		.target_WB(reg_write_addr),
		.ALU_data_WB(ALU_data_WB),
		.MEM_data_WB(MEM_data_WB),
		.we_hi_WB(we_hi),
		.we_lo_WB(we_lo),
		.hi_WB(hi_data_in),
		.lo_WB(lo_data_in),
		.WriteReg_WB(reg_we),
		.MemOrAlu_WB(MemOrAlu_WB)
	);

	// See define.v
	// MemOrAlu
	// `define ALU 			1'b1
	// `define Mem 			1'b0

	mux2x1 #(.data_width(`RegDataWidth)) result_mux(
		.in_0(MEM_data_WB),
		.in_1(ALU_data_WB),
		.slct(MemOrAlu_WB),
		.out(reg_write_data)
	);

	// Control center
	ForwardControl forwarding_handler(
		.rst(rst),
		.reg_data_1_addr_ID(raddr_1_ID),
		.reg_data_2_addr_ID(raddr_2_ID),

		.reg_data_1_addr_EX(raddr_1_EX),
		.reg_data_2_addr_EX(raddr_2_EX),
		.target_EX(target_EX),
		.WriteReg_EX(WriteReg_EX),

		.reg_data_2_addr_MEM(raddr_2_MEM),
		.target_MEM(target_MEM),
		.WriteReg_MEM(WriteReg_MEM),
		.MemOrAlu_MEM(MemOrAlu_MEM),
		.we_hi_MEM(we_hi_MEM),
		.we_lo_MEM(we_lo_MEM),

		.target_WB(reg_write_addr),
		.WriteReg_WB(reg_we),
		.we_hi_WB(we_hi),
		.we_lo_WB(we_lo),

		.FWA(FWA),
		.FWB(FWB),
		.FWhi(FWhi),
		.FWlo(FWlo),
		.FWLS(FWLS),
		.FW_br_A(FW_br_A),
		.FW_br_B(FW_br_B)
	);
	BranchControl branch_handler(
		.rst(rst),
		.pc_plus4_ID(pc_plus4_ID),
		.inst_ID(inst_ID),

		.FW_br_A(FW_br_A),
		.FW_br_B(FW_br_A),
		.rdata_1_ID(rdata_1_ID),
		.rdata_2_ID(rdata_2_ID),
		.data_out_EX(data_out_EX),
		.data_from_ALU_MEM(data_from_ALU_MEM),
		.MEM_data_MEM(MEM_data_MEM),

		.branch_address(branch_address),
		.is_branch(is_branch),
		.is_rst_IF_ID(is_rst_IF_ID)
	);
	HazardControl hazard_handler(
		.rst(rst),
		.ReadMem_EX(ReadMem_EX),
		.raddr_1_ID(raddr_1_ID),
		.raddr_2_ID(raddr_2_ID),
		.target_EX(target_EX),
		.is_hold_IF(is_hold_IF),
		.is_hold_IF_ID(is_hold_IF_ID),
		.is_zeros_ID_EX(is_zeros_ID_EX)
	);
endmodule