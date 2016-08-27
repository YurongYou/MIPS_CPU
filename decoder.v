module decoder (
	input								rst,
	input[`InstDataWidth-1:0] 			inst,

	output reg 							WriteReg,
	output reg							MemOrAlu,
	output reg							WriteMem,
	output reg							ReadMem,
	output reg[`ALUTypeWidth-1:0]		AluType,
	output reg[`ALUOpWidth-1:0]			AluOp,
	output reg							AluSrcA,
	output reg							AluSrcB,
	output reg							RegDes,
	output reg 							ImmSigned,
	output 								is_jal
);
	wire[`OpcodeBus]			opcode;
	wire[`FunctBus]				funct;

	assign opcode 	= inst[`OpcodeBus];
	assign funct 	= inst[`FunctBus];
	assign is_jal	= (opcode == `mips_jal) ? 1'b1 : 1'b0;

	always @(*) begin : proc_decode
		if (rst == ~`RstEnable) begin
			case (opcode)
				`mips_R: begin
					case (funct)
						// Note that in Logic Op, rd <- rt >>(<<) rs(shamt)
						// 						  rd <= ALUSrcB >>(<<) ALUSrcA
						// ALUSrcB = rt
						`mips_sll: begin
							//sll $1,$2,10
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							MemOrAlu 	= `ALU;
							AluType	 	= `ALU_SHIFT;
							AluOp	 	= `Sll;
							AluSrcA  	= `Shamt;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_srl: begin
							//srl $1,$2,10
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							MemOrAlu 	= `ALU;
							AluType	 	= `ALU_SHIFT;
							AluOp	 	= `Srl;
							AluSrcA  	= `Shamt;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_sra: begin
							//sra $1,$2,10
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							MemOrAlu 	= `ALU;
							AluType	 	= `ALU_SHIFT;
							AluOp	 	= `Sra;
							AluSrcA  	= `Shamt;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_sllv: begin
							//sllv $1,$2,$3
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							MemOrAlu 	= `ALU;
							AluType	 	= `ALU_SHIFT;
							AluOp	 	= `Sll;
							AluSrcA  	= `Rs;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_srlv: begin
							//srlv $1,$2,$3
							WriteReg	= `WriteEnable;
							WriteMem	= ~`WriteEnable;
							ReadMem		= ~`ReadEnable;
							MemOrAlu	= `ALU;
							AluType		= `ALU_SHIFT;
							AluOp		= `Srl;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_srav: begin
							//srav $1,$2,$3
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							MemOrAlu 	= `ALU;
							AluType	 	= `ALU_SHIFT;
							AluOp	 	= `Sra;
							AluSrcA  	= `Rs;
							AluSrcB  	= `Rt;
							RegDes   	= `Rd;
						end
						`mips_jr: begin
							// jr $31
							WriteReg 	= ~`WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
						end
						`mips_mfhi: begin
							// mfhi $d
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_OTHER;
							AluOp		= `Mfhi;
							RegDes		= `Rd;
						end
						`mips_mflo: begin
							// mflo $d
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_OTHER;
							AluOp		= `Mfhi;
							RegDes		= `Rd;
						end
						`mips_mult: begin
							WriteReg 	= ~`WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							AluType 	= `ALU_MUL_DIV;
							AluOp 		= `Mult;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_multu: begin
							WriteReg 	= ~`WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							AluType 	= `ALU_MUL_DIV;
							AluOp 		= `Multu;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_div: begin
							WriteReg 	= ~`WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							AluType 	= `ALU_MUL_DIV;
							AluOp 		= `Div;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_divu: begin
							WriteReg 	= ~`WriteEnable;
							WriteMem 	= ~`WriteEnable;
							ReadMem  	= ~`ReadEnable;
							AluType 	= `ALU_MUL_DIV;
							AluOp 		= `Divu;
							AluSrcA 	= `Rs;
							AluSrcB 	= `Rt;
						end
						`mips_add: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_ADD_SUB;
							AluOp		= `Add;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_addu: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_ADD_SUB;
							AluOp		= `Addu;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_sub: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_ADD_SUB;
							AluOp		= `Sub;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_subu: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_ADD_SUB;
							AluOp		= `Subu;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_and: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_LOGIC;
							AluOp		= `And;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_or: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_LOGIC;
							AluOp		= `Or;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_xor: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_LOGIC;
							AluOp		= `Xor;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_nor: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_LOGIC;
							AluOp		= `Nor;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_slt: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_COMP;
							AluOp		= `Slt;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						`mips_sltu: begin
							WriteReg 	= `WriteEnable;
							WriteMem 	= ~`WriteEnable;
							MemOrAlu	= `ALU;
							ReadMem  	= ~`ReadEnable;
							AluType		= `ALU_COMP;
							AluOp		= `Sltu;
							AluSrcA		= `Rs;
							AluSrcB		= `Rt;
							RegDes		= `Rd;
						end
						default: begin
							WriteReg	= ~`WriteEnable;
							WriteMem	= ~`WriteEnable;
							ReadMem		= ~`ReadEnable;
						end
					endcase // funct
				end
				`mips_jal: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
				end
				`mips_beq: begin
					WriteReg 	= ~`WriteEnable;
					WriteMem 	= ~`WriteEnable;
					ReadMem  	= ~`ReadEnable;
				end
				`mips_bne: begin
					WriteReg 	= ~`WriteEnable;
					WriteMem 	= ~`WriteEnable;
					ReadMem  	= ~`ReadEnable;
				end
				`mips_addi: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Add;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_addiu: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_slti: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_COMP;
					AluOp		= `Slt;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_andi: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_LOGIC;
					AluOp		= `And;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_ori: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_LOGIC;
					AluOp		= `Or;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_xori: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `ALU;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_LOGIC;
					AluOp		= `Xor;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_lui: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `Mem;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_OTHER;
					AluOp		= `Lui;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= ~`ImmSign;
				end
				`mips_lb: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_lh: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_lw: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_lbu: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_lhu: begin
					WriteReg 	= `WriteEnable;
					WriteMem 	= ~`WriteEnable;
					MemOrAlu	= `Mem;
					ReadMem  	= `ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					RegDes		= `Rt;
					ImmSigned	= `ImmSign;
				end
				`mips_sb: begin
					WriteReg 	= ~`WriteEnable;
					WriteMem 	= `WriteEnable;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					ImmSigned	= `ImmSign;
				end
				`mips_sh: begin
					WriteReg 	= ~`WriteEnable;
					WriteMem 	= `WriteEnable;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					ImmSigned	= `ImmSign;
				end
				`mips_sw: begin
					WriteReg 	= ~`WriteEnable;
					WriteMem 	= `WriteEnable;
					ReadMem  	= ~`ReadEnable;
					AluType		= `ALU_ADD_SUB;
					AluOp		= `Addu;
					AluSrcA		= `Rs;
					AluSrcB		= `Imm;
					ImmSigned	= `ImmSign;
				end
				default: begin
					WriteReg	= ~`WriteEnable;
					WriteMem	= ~`WriteEnable;
					ReadMem		= ~`ReadEnable;
				end
			endcase // opcode
		end
		else begin
			WriteReg	= ~`WriteEnable;
			WriteMem	= ~`WriteEnable;
			ReadMem		= ~`ReadEnable;
		end
	end
endmodule