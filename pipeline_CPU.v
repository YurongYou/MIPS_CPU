// `include "define.v"
// `include "regfile.v"
// `include "IF.v"
// `include "IF_ID.v"
// `include "ID.v"
// `include "ID_EX.v"
// `include "decoder.v"
// `include "utilities/dffe.v"
// `include "utilities/mux2x1.v"
module pipeline_CPU (clk, rst, rom_data_in, mem_data_in,
		mem_addr, mem_data_out, rom_addr, rom_ce, mem_we, mem_re);
	input 						clk;
	input 						rst;
	input[`InstDataWidth-1:0] 	rom_data_in;
	input[`RegDataWidth-1:0]	mem_data_in;

	output[`MemAddrWidth-1:0]	mem_addr;
	output[`RegDataWidth-1:0]	mem_data_out;
	output[`InstAddrWidth-1:0] 	rom_addr;
	output						rom_ce;
	output						mem_we;
	output						mem_re;

	supply1 vcc;
	supply0 gnd;


	// TODO: connect the branch control module
	wire[`InstAddrWidth-1:0]	branch_address;
	wire is_branch;
	// TODO: connect to the control module
	// Hazard Control Port
	wire is_hold_IF;
	wire is_hold_IF_ID;
	wire is_rst_ID_EX;

	wire[`InstAddrWidth-1:0] pc_plus4_IF;
	wire[`InstDataWidth-1:0] inst_IF;

	wire[`InstDataWidth-1:0] inst_ID;
	wire[`InstAddrWidth-1:0] pc_plus4_ID;

	IF inst_fetch(.clk      (clk),
		.rst      (rst),
		.is_hold  (is_hold_IF),
		.is_branch(is_branch),
		.branch_address(branch_address),
		.ce(rom_ce),
		.pc(rom_addr),
		.pc_plus4(pc_plus4_IF));



	IF_ID if_id_reg(.clk        (clk),
		.rst        (rst),
		.is_hold    (is_hold_IF_ID),
		.pc_plus4_IF(pc_plus4_IF),
		.inst_IF    (rom_data_in),
		.pc_plus4_ID(pc_plus4_ID),
		.inst_ID    (inst_ID)
		);

	// wire						re1;
	wire[`RegAddrWidth-1:0]		raddr_1_ID;
	wire[`RegDataWidth-1:0]		rdata_1_ID;
	// wire						re2;
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
	wire[`RegAddrWidth-1:0] 	rt_ID;
	wire[`RegAddrWidth-1:0] 	rd_ID;
	wire[`RegDataWidth-1:0]	  	imm_signed_ID;
	wire[`RegDataWidth-1:0]	  	imm_unsigned_ID;

	ID inst_decode(rst, pc_plus4_ID, inst_ID, raddr_1_ID, raddr_2_ID, WriteReg_ID, MemOrAlu_ID, WriteMem_ID, ReadMem_ID, AluType_ID, AluOp_ID, AluSrcA_ID, AluSrcB_ID, RegDes_ID, ImmSigned_ID, rt_ID, rd_ID, imm_signed_ID, imm_unsigned_ID, shamt_ID);

	wire[`RegAddrWidth-1:0]		reg_write_addr;
	wire[`RegDataWidth-1:0]		reg_write_data;
	wire						reg_we;

	wire we_hi;
	wire[`RegDataWidth-1:0] hi_data_in;

	wire we_lo;
	wire[`RegDataWidth-1:0] lo_data_in;

	wire[`RegDataWidth-1:0] hi_data_out_ID;
	wire[`RegDataWidth-1:0] lo_data_out_ID;
	wire[`RegDataWidth-1:0] hi_data_to_EX;
	wire[`RegDataWidth-1:0] lo_data_to_EX;

	// force read regfile
	regfile regs(clk, rst,
		reg_write_addr,
		reg_write_data,
		reg_we,
		vcc, raddr_1_ID, rdata_1_ID, vcc, raddr_2_ID, rdata_2_ID);

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
	wire[`RegAddrWidth-1:0] 	rt_EX;
	wire[`RegAddrWidth-1:0] 	rd_EX;
	wire[`RegDataWidth-1:0]	  	imm_signed_EX;
	wire[`RegDataWidth-1:0]	  	imm_unsigned_EX;
	wire[`RegDataWidth-1:0]		rdata_1_EX;
	wire[`RegDataWidth-1:0]		rdata_2_EX;
	wire[`RegAddrWidth-1:0]		raddr_1_EX;
	wire[`RegAddrWidth-1:0]		raddr_2_EX;
	wire[`RegDataWidth-1:0]		shamt_EX;

	ID_EX id_ex_reg(
	.clk(clk),
	.rst(rst),
	// set gnd temporarily
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
	.rt_ID(rt_ID),
	.rd_ID(rd_ID),
	.imm_signed_ID(imm_signed_ID),
	.imm_unsigned_ID(imm_unsigned_ID),
	.hi_ID(hi_data_out_ID),
	.lo_ID(lo_data_out_ID),

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
	.rt_EX(rt_EX),
	.rd_EX(rd_EX),
	.imm_signed_EX(imm_signed_EX),
	.imm_unsigned_EX(imm_unsigned_EX)
	.hi_EX(hi_data_to_EX),
	.lo_EX(lo_data_to_EX),
	);

	wire[`RegAddrWidth-1:0]		target_EX;
	wire						is_Overflow;
	wire[`RegDataWidth-1:0]		data_out;
	wire						we_hi_EX;
	wire						we_lo_EX;
	wire[`RegDataWidth-1:0]		hi_EX;
	wire[`RegDataWidth-1:0]		lo_EX;
	wire[`RegDataWidth-1:0]		rdata_2_EX_out;

	// TODO: connect the forwarding module

	EX execution(
	.rst(rst),
	.shamt(shamt_EX),
	.AluType_EX(AluType_EX),
	.AluOp_EX(AluOp_EX),
	.AluSrcA_EX(AluSrcA_EX),
	.AluSrcB_EX(AluSrcB_EX),
	.RegDes_EX(RegDes_EX),
	.ImmSigned_EX(ImmSigned_EX),
	.rt_EX(rt_EX),
	.rd_EX(rd_EX),
	.imm_signed_EX(imm_signed_EX),
	.imm_unsigned_EX(imm_unsigned_EX),
	.hi(hi_data_to_EX),
	.lo(lo_data_to_EX),
	.rdata_1(rdata_1_EX),
	.rdata_2(rdata_2_EX),
	.data_out_MEM(),
	.data_out_WB(),
	.hi_MEM(),
	.hi_WB(),
	.lo_MEM(),
	.lo_WB(),
	.FWA(),
	.FWB(),
	.FWhi(),
	.FWlo(),

	.target_EX(target_EX),
	.is_Overflow(is_Overflow),
	.data_out(data_out),
	.rdata_2_EX(rdata_2_EX_out),
	.hi_EX(hi_EX),
	.lo_EX(lo_EX),
	.we_hi(we_hi_EX),
	.we_lo(we_lo_EX)
	);

	wire[`RegAddrWidth-1:0]		target_MEM;
	wire[`RegDataWidth-1:0]		data_in_MEM;
	wire						we_hi_MEM;
	wire						we_lo_MEM;
	wire[`RegDataWidth-1:0]		hi_MEM;
	wire[`RegDataWidth-1:0]		lo_MEM;
	wire[`RegDataWidth-1:0]		rdata_2_MEM;
	wire						WriteReg_MEM;
	wire						MemOrAlu_MEM;
	wire						WriteMem_MEM;
	wire						ReadMem_MEM;

	EX_MEM ex_mem_reg(
	.clk(clk),
	.rst(rst),
	// set gnd temporarily
	.is_hold(gnd),
	.target_EX(target_EX),
	.data_out_EX(data_out),
	.we_hi_EX(we_hi_EX),
	.we_lo_EX(we_lo_EX),
	.hi_EX(hi_EX),
	.lo_EX(lo_EX),
	.rdata_2_EX(rdata_2_EX_out),
	.WriteReg_EX(WriteReg_EX),
	.MemOrAlu_EX(MemOrAlu_EX),
	.WriteMem_EX(WriteMem_EX),
	.ReadMem_EX(ReadMem_EX),

	.target_MEM(target_MEM),
	.data_in_MEM(data_in_MEM),
	.we_hi_MEM(we_hi_MEM),
	.we_lo_MEM(we_lo_MEM),
	.hi_MEM(hi_MEM),
	.lo_MEM(lo_MEM),
	.rdata_2_MEM(rdata_2_MEM),
	.WriteReg_MEM(WriteReg_MEM),
	.MemOrAlu_MEM(MemOrAlu_MEM),
	.WriteMem_MEM(WriteMem_MEM),
	.ReadMem_MEM(ReadMem_MEM),
	);

	// memory operation
	assign mem_addr = data_in_MEM;
	assign mem_data_out = rdata_2_MEM;
	assign mem_re = ReadMem_MEM;
	assign mem_we = WriteMem_MEM;

	wire[`RegDataWidth-1:0]		ALU_data_WB;
	wire[`RegDataWidth-1:0]		MEM_data_out_WB;

	MEM_WB mem_wb_reg(
	.clk(clk),
	.rst(rst),
	// set gnd temporarily
	.is_hold(gnd),
	.target_MEM(target_MEM),
	.ALU_data_MEM(data_in_MEM),
	.MEM_data_out_MEM(mem_data_in),
	.we_hi_MEM(we_hi_MEM),
	.we_lo_MEM(we_lo_MEM),
	.hi_MEM(hi_MEM),
	.lo_MEM(lo_MEM),
	.WriteReg_MEM(WriteReg_MEM),
	.MemOrAlu_MEM(MemOrAlu_MEM),

	.target_WB(reg_write_addr),
	.ALU_data_WB(ALU_data_WB),
	.MEM_data_out_WB(MEM_data_out_WB),
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
		.in_0(MEM_data_out_WB),
		.in_1(ALU_data_WB),
		.slct(MemOrAlu_WB),
		.out(reg_write_data)
		);

endmodule