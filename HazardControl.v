module HazardControl (
	input 						rst,
	input						ReadMem_EX,
	input[`RegAddrWidth-1:0]	raddr_1_ID,
	input[`RegAddrWidth-1:0]	raddr_2_ID,
	input[`RegAddrWidth-1:0]	target_EX,

	output						is_hold_IF,
	output						is_hold_IF_ID,
	output						is_zeros_ID_EX
);

endmodule