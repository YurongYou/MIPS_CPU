// `include "define.v"
module BranchControl (
	input							rst,

	input[`InstAddrWidth-1:0] 		pc_plus4_ID,
	input[`InstDataWidth-1:0] 		inst_ID,

	input[1:0]						FW_br_A,
	input[1:0]						FW_br_B,
	input[`RegDataWidth-1:0]		rdata_1_ID,
	input[`RegDataWidth-1:0]		rdata_2_ID,
	input[`RegDataWidth-1:0]		data_out_EX,
	input[`RegDataWidth-1:0]		data_from_ALU_MEM,
	input[`RegDataWidth-1:0]		MEM_data_MEM,

	output reg[`InstAddrWidth-1:0]	branch_address,
	output reg						is_branch,
	output reg						is_rst_IF_ID
);
	reg[`RegDataWidth-1:0]			opA;
	reg[`RegDataWidth-1:0]			opB;

	always @(*) begin : proc_set_opA
		case (FW_br_A)
			`FW_br_EX_ALU : opA <= data_out_EX;
			`FW_br_MEM_MEM: opA <= MEM_data_MEM;
			`FW_br_MEM_ALU: opA <= data_from_ALU_MEM;
			`FW_br_Origin : opA <= rdata_1_ID;
			default : begin
			end
		endcase
	end

	always @(*) begin : proc_set_opB
		case (FW_br_B)
			`FW_br_EX_ALU : opB <= data_out_EX;
			`FW_br_MEM_MEM: opB <= MEM_data_MEM;
			`FW_br_MEM_ALU: opB <= data_from_ALU_MEM;
			`FW_br_Origin : opB <= rdata_2_ID;
			default : begin
			end
		endcase
	end
	wire[`InstAddrWidth-1:0]	j_addr;
	wire[`InstAddrWidth-1:0]	cond_addr;
	wire[`InstAddrWidth-1:0]	jr_addr;

	assign j_addr = {pc_plus4_ID[31:28], inst_ID[`AddrBus], 2'b00};
	assign cond_addr = pc_plus4_ID + {{16{inst_ID[15]}}, inst_ID[`ImmBus]};
	assign jr_addr = opA;

	always @(*) begin : proc_branch
		if (rst == ~`RstEnable) begin
			case (inst_ID[`OpcodeBus])
				`mips_R: begin
					if (inst_ID[`FunctBus] == `mips_jr) begin
						branch_address <= jr_addr;
						is_branch <= `BranchEnable;
						is_rst_IF_ID <= `RstEnable;
					end
					else begin
						branch_address <= `ZeroWord;
						is_branch <= ~`BranchEnable;
						is_rst_IF_ID <= ~`RstEnable;
					end
				end
				`mips_j: begin
					branch_address <= j_addr;
					is_branch <= `BranchEnable;
					is_rst_IF_ID <= `RstEnable;
				end
				`mips_jal: begin
					branch_address <= j_addr;
					is_branch <= `BranchEnable;
					is_rst_IF_ID <= `RstEnable;
				end
				`mips_beq: begin
					if (opA == opB) begin
						branch_address <= cond_addr;
						is_branch <= `BranchEnable;
						is_rst_IF_ID <= `RstEnable;
					end
					else begin
						branch_address <= `ZeroWord;
						is_branch <= ~`BranchEnable;
						is_rst_IF_ID <= ~`RstEnable;
					end
				end
				`mips_bne: begin
					if (opA != opB) begin
						branch_address <= cond_addr;
						is_branch <= `BranchEnable;
						is_rst_IF_ID <= `RstEnable;
					end
					else begin
						branch_address <= `ZeroWord;
						is_branch <= ~`BranchEnable;
						is_rst_IF_ID <= ~`RstEnable;
					end
				end
				default : begin
					branch_address <= `ZeroWord;
					is_branch <= ~`BranchEnable;
					is_rst_IF_ID <= ~`RstEnable;
				end
			endcase
		end
		else begin
			branch_address <= `ZeroWord;
			is_branch <= ~`BranchEnable;
			is_rst_IF_ID <= ~`RstEnable;
		end
	end

endmodule