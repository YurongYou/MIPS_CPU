module MEM (
	input rst,

	input							FWLS,
	input[`RegDataWidth-1:0]		reg_data_2,
	input[`RegDataWidth-1:0]		WB_data,
	input[`RegDataWidth-1:0]		raw_mem_data,
	input 							ReadMem,
	input							WriteMem,

	input[`RegDataWidth-1:0]		mem_addr,
	input[`OpcodeWidth-1:0]			opcode,

	output[`RegDataWidth-1:0]		data_to_write_mem,
	output[`RegDataWidth-1:0]		data_to_reg,
	output reg[`ByteSlctWidth-1:0]	byte_slct
);

	wire[`RegDataWidth-1:0]		raw_reg_data;
	wire[`ByteSlctWidth-1:0]	byte_slct_b;
	wire[`ByteSlctWidth-1:0]	byte_slct_h;

	assign byte_slct_b = `ByteSlctWidth'b1000 >> mem_addr[1:0];
	assign byte_slct_h = `ByteSlctWidth'b1100 >> mem_addr[1:0];

	always @(*) begin : proc_byte_slct_gen
		case (opcode)
			`mips_lb  : byte_slct <= byte_slct_b;
			`mips_lh  : byte_slct <= byte_slct_h;
			`mips_lw  : byte_slct <= `ByteSlctWidth'b1111;
			`mips_lbu : byte_slct <= byte_slct_b;
			`mips_lhu : byte_slct <= byte_slct_h;
			`mips_sb  : byte_slct <= byte_slct_b;
			`mips_sh  : byte_slct <= byte_slct_h;
			`mips_sw  : byte_slct <= `ByteSlctWidth'b1111;
			default : byte_slct <= 0;
		endcase
	end

	mux2x1 #(.data_width(`RegDataWidth)) forwardLS(
		.in_0(reg_data_2),
		.in_1(WB_data),
		.slct(FWLS),
		.out(raw_reg_data)
	);

	WM_ctrl write_control(
		.rst(rst),
		.raw_reg_data(raw_reg_data),
		.opcode(opcode),

		.data_to_mem(data_to_write_mem)
	);

	RM_ctrl read_control(
		.rst(rst),
		.byte_slct(byte_slct),
		.opcode(opcode),
		.raw_mem_data(raw_mem_data),

		.data_to_reg(data_to_reg)
	);
endmodule