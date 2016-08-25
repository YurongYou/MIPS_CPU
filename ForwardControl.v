module ForwardControl (
	input[`RegAddrWidth-1:0]	reg_data_1_addr_EX,
	input[`RegAddrWidth-1:0]	reg_data_2_addr_EX,

	input[`RegAddrWidth-1:0]	reg_data_2_addr_MEM,
	input[`RegAddrWidth-1:0]	target_MEM,
	input						WriteReg_MEM,
	input						we_hi_MEM,
	input						we_lo_MEM,

	input[`RegAddrWidth-1:0]	target_WB,
	input						WriteReg_WB,
	input						we_hi_WB,
	input						we_lo_WB,

	output[1:0]					FWA,
	output[1:0]					FWB,
	output[1:0]					FWhi,
	output[1:0]					FWlo,
	output						FWLS
);
	// TODO
endmodule