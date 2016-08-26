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
	output							is_branch,
	output							is_rst_IF_ID
);
	wire[`InstAddrWidth-1:0]	j_addr;
	wire[`InstAddrWidth-1:0]	imm_addr;
	wire[`InstAddrWidth-1:0]	jr_addr;
	wire[`InstAddrWidth-1:0]	condition_addr;

	assign j_addr = {pc_plus4_ID[31:28], inst_ID[`AddrBus], 2'b00};
	assign imm_addr = pc_plus4_ID + {{16{inst[15]}}, inst[`ImmBus]};

	always @(*) begin : proc_branch
		if (rst == ~`RstEnable) begin

		end
		else begin
			branch_address <= `ZeroWord;
			is_branch <= ~`BranchEnable;
			is_rst_IF_ID <= ~`RstEnable;
		end
	end

	function set_jr_addr;
		input[`RegAddrWidth-1:0]		raddr_1_ID;
		input[`RegDataWidth-1:0]		rdata_1_ID;

		input[`RegAddrWidth-1:0]		target_EX;
		input[`RegDataWidth-1:0]		data_out_EX;

		input[`RegAddrWidth-1:0]		target_MEM;
		input[`RegDataWidth-1:0]		data_from_ALU_MEM;

		input[`RegAddrWidth-1:0]		target_WB;
		input[`RegDataWidth-1:0]		WB_data;

		if ()
	endfunction : set_jr_addr
endmodule