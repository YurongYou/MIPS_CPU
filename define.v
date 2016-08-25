`ifndef PIPELINE_DEF
`define PIPELINE_DEF
`timescale 1ns/100ps

`define RstEnable		1'b1
`define HoldEnable		1'b1
`define BranchEnable	1'b1
`define WriteEnable		1'b1
`define ReadEnable		1'b1
`define ChipEnable		1'b1
`define Overflow		1'b1
`define ImmSign			1'b1

// MemOrAlu
`define ALU 			1'b1
`define Mem 			1'b0

//AluSrcA
`define Rs 				1'b1
`define Shamt 			1'b0

//AluSrcB
`define Imm 			1'b1
`define Rt 				1'b0

//RegDes
`define Rd 				1'b1
`define Rt 				1'b0

`define ByteSlctWidth	4
`define MemAddrWidth	32
`define InstAddrWidth	32
`define InstDataWidth	32
`define OpcodeWidth		6
`define FunctWidth		6
`define ImmWidth		16
`define AddrWidth 		26
`define OpcodeBus		31:26
`define FunctBus		5:0
`define RsBus			25:21
`define RtBus			20:16
`define RdBus			15:11
`define SaBus			10:6
`define ImmBus			15:0
`define AddrBus			25:0



`define ZeroWord		32'b0

`define RegNum			32
`define RegAddrWidth	5
`define RegDataWidth	32


// alu Type
`define ALU_ADD_SUB		2'b00
`define ALU_MUL_DIV		2'b01
`define ALU_LOGIC		2'b10
`define ALU_SHIFT		2'b11

// alu Opcode
// `ALU_ADD_SUB
`define Add 			2'b00
`define Addu 			2'b10
`define Sub 			2'b01
`define Subu 			2'b11

// `ALU_MUL_DIV
`define Mult 			2'b00
`define Multu 			2'b10
`define Div 			2'b01
`define Divu 			2'b11

// `ALU_LOGIC
`define And				2'b00
`define Or				2'b10
`define Xor				2'b01
`define Nor				2'b11

// `ALU_SHIFT
`define Sll				2'b00
`define Srl				2'b01
`define Sra				2'b11

// MIPS opcode
`define mips_R			6'h0
`define mips_j			6'h2
`define mips_jal		6'h3
`define mips_beq		6'h4
`define mips_bne		6'h5
`define mips_addi		6'h8
`define mips_addiu		6'h9
`define mips_slti		6'ha
`define mips_andi		6'hc
`define mips_ori		6'hd
`define mips_xori		6'he
`define mips_lui		6'hf
`define mips_lb			6'h20
`define mips_lh			6'h21
`define mips_lw			6'h23
`define mips_lbu		6'h24
`define mips_lhu		6'h25
`define mips_sb			6'h28
`define mips_sh			6'h29
`define mips_sw			6'h2b

// MIPS funct
`define mips_sll 		6'd0
`define mips_srl 		6'd2
`define mips_sra 		6'd3
`define mips_sllv 		6'd4
`define mips_srlv 		6'd6
`define mips_srav 		6'd7
`define mips_jr 		6'd8
`define mips_mfhi 		6'd16
`define mips_mflo 		6'd18
`define mips_mult 		6'd24
`define mips_multu 		6'd25
`define mips_div 		6'd26
`define mips_divu 		6'd27
`define mips_add 		6'd32
`define mips_addu 		6'd33
`define mips_sub 		6'd34
`define mips_subu 		6'd35
`define mips_and 		6'd36
`define mips_or 		6'd37
`define mips_xor 		6'd38
`define mips_nor 		6'd39
`define mips_slt 		6'd42
`define mips_sltu 		6'd43


// forwarding info
`define FWOrigin		2'b00
`define FWMem			2'b01
`define FWWB			2'b10
`endif