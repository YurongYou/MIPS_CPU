module BranchControl (
	input						rst,

	input[`InstAddrWidth-1:0] 	pc_plus4_ID,
	input[`InstDataWidth-1:0] 	inst_ID,

	input[`RegAddrWidth-1:0]	raddr_1_ID,
	input[`RegDataWidth-1:0]	rdata_1_ID,
	input[`RegAddrWidth-1:0]	raddr_2_ID,
	input[`RegDataWidth-1:0]	rdata_2_ID,

	input[`RegAddrWidth-1:0]	target_EX,
	input[`RegDataWidth-1:0]	data_out_EX,

	input[`RegAddrWidth-1:0]	target_MEM,
	input[`RegDataWidth-1:0]	data_from_ALU_MEM,

	input[`RegAddrWidth-1:0]	target_WB,
	input[`RegDataWidth-1:0]	WB_data,

	output[`InstAddrWidth-1:0]	branch_address,
	output						is_branch
);
	// TODO
endmodule