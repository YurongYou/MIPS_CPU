module MEM (
	input rst,

	input						FWLS,
	input[`RegDataWidth-1:0]	reg_data_2,
	input[`RegDataWidth-1:0]	WB_data,
	input[`RegDataWidth-1:0]	raw_mem_data,
	input 						ReadMem,
	input						WriteMem,
	input[`ByteSlctWidth-1:0]	byte_slct,

	output[`RegDataWidth-1:0]	data_to_write_mem,
	output[`RegDataWidth-1:0]	data_to_reg
);

	wire[`RegDataWidth-1:0]		raw_reg_data;

	mux2x1 #(.data_width(`RegDataWidth)) forwardLS(
		.in_0(reg_data_2),
		.in_1(WB_data),
		.slct(FWLS),
		.out(raw_reg_data)
	);

	WM_ctrl write_control(
		.rst(rst),
		.raw_reg_data(raw_reg_data),
		.byte_slct_MEM(byte_slct),
		.data_to_mem(data_to_write_mem)
	);

	RM_ctrl read_control(
		.rst(rst),
		.byte_slct(byte_slct),
		.raw_mem_data(raw_mem_data),
		.data_to_reg(data_to_reg)
	);
endmodule