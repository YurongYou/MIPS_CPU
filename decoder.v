module decoder (
	input								rst,
	input[`InstDataWidth-1:0] 			inst,

	output reg 							WriteReg,
	output reg							MemOrAlu,
	output reg							WriteMem,
	output reg							ReadMem,
	output reg[1:0]						AluType,
	output reg[1:0]						AluOp,
	output reg							AluSrcA,
	output reg							AluSrcB,
	output reg							RegDes,
	output reg 							ImmSigned,
	output reg[`ByteSlctWidth-1:0]		byte_slct,
	output reg 							is_jal,
	output reg 							mfhi_lo
);
	// TODO
	wire[`OpcodeBus]			opcode;
	wire[`FunctBus]				funct;

	always @(*) begin : proc_decode
		if (rst == ~`RstEnable) begin
			case (opcode)
				`mips_R: begin
					case (funct)
						// Note that in Logic Op, rt <- rt >>(<<) rs(shamt)
						// 						  rt <= ALUSrcB >>(<<) ALUSrcA
						// ALUSrcB = rt
						`mips_sll: begin
							//sll $1,$2,10
							WriteReg = `WriteEnable;
							WriteMem = ~`WriteEnable;
							MemOrAlu = `ALU;
							AluType	 = `ALU_SHIFT;
							AluOp	 = `Sll;
							AluSrcA  = `Shamt;
							AluSrcB  = `Rt;
							RegDes   = `Rd;
						end
						`mips_srl: begin
							//srl $1,$2,10
							WriteReg = `WriteEnable;
							WriteMem = ~`WriteEnable;
							MemOrAlu = `ALU;
							AluType	 = `ALU_SHIFT;
							AluOp	 = `Srl;
							AluSrcA  = `Shamt;
							AluSrcB  = `Rt;
							RegDes   = `Rd;
						end
						`mips_sra: begin
							//sra $1,$2,10
							WriteReg = `WriteEnable;
							WriteMem = ~`WriteEnable;
							MemOrAlu = `ALU;
							AluType	 = `ALU_SHIFT;
							AluOp	 = `Sra;
							AluSrcA  = `Shamt;
							AluSrcB  = `Rt;
							RegDes   = `Rd;
						end
						`mips_sllv: begin
							//sllv $1,$2,$3
							WriteReg = `WriteEnable;
							WriteMem = ~`WriteEnable;
							MemOrAlu = `ALU;
							AluType	 = `ALU_SHIFT;
							AluOp	 = `Sll;
							AluSrcA  = `Rs;
							AluSrcB  = `Rt;
							RegDes   = `Rd;
						end
						`mips_srlv: begin
							//srlv $1,$2,$3
							WriteReg = `WriteEnable;
							WriteMem = ~`WriteEnable;
							MemOrAlu = `ALU;
							AluType	 = `ALU_SHIFT;
							AluOp	 = `Srl;
							AluSrcA  = `Rs;
							AluSrcB  = `Rt;
							RegDes   = `Rd;
						end
						`mips_srav: begin
							//srav $1,$2,$3
							WriteReg = `WriteEnable;
							WriteMem = ~`WriteEnable;
							MemOrAlu = `ALU;
							AluType	 = `ALU_SHIFT;
							AluOp	 = `Sra;
							AluSrcA  = `Rs;
							AluSrcB  = `Rt;
							RegDes   = `Rd;
						end
						`mips_jr: begin
							// TODO
						end
						`mips_mfhi: begin
						end
						`mips_mflo: begin
						end
						`mips_mult: begin
						end
						`mips_mult: begin
						end
						`mips_div: begin
						end
						`mips_divu: begin
						end
						`mips_add: begin
						end
						`mips_addu: begin
						end
						`mips_sub: begin
						end
						`mips_subu: begin
						end
						`mips_and: begin
						end
						`mips_or: begin
						end
						`mips_xor: begin
						end
						`mips_nor: begin
						end
						`mips_slt: begin
						end
						`mips_sltu: begin
						end
						default: begin
						end
					endcase // funct
				end
				`mips_jal: begin
				end
				`mips_beq: begin
				end
				`mips_bne: begin
				end
				`mips_addi: begin
				end
				`mips_addiu: begin
				end
				`mips_slti: begin
				end
				`mips_andi: begin
				end
				`mips_ori: begin
				end
				`mips_xori: begin
				end
				`mips_lui: begin
				end
				`mips_lb: begin
				end
				`mips_lh: begin
				end
				`mips_lw: begin
				end
				`mips_lbu: begin
				end
				`mips_lhu: begin
				end
				`mips_sb: begin
				end
				`mips_sh: begin
				end
				`mips_sw: begin
				end
				default: begin
				end
			endcase // opcode
		end
		else begin
			WriteReg = ~`WriteEnable;
			WriteMem = ~`WriteEnable;
		end
	end
endmodule