module RM_ctrl (
	input 							rst,
	input[`ByteSlctWidth-1:0]		byte_slct,
	input[`OpcodeWidth-1:0]			opcode,
	input[`RegDataWidth-1:0]		raw_mem_data,

	output reg[`RegDataWidth-1:0]	data_to_reg
);
	reg[`ByteBus]					read_byte;
	reg[`HalfWordBus]				read_half_word;

	always @(*) begin : proc_read_byte
		case (byte_slct)
			4'b1000 : read_byte <= raw_mem_data[31:24];
			4'b0100 : read_byte <= raw_mem_data[23:16];
			4'b0010 : read_byte <= raw_mem_data[15:8];
			4'b0001 : read_byte <= raw_mem_data[7:0];
			default : read_byte <= `ZeroWord;
		endcase
	end

	always @(*) begin : proc_read_half_word
		case (byte_slct)
			4'b1100 : read_half_word <= raw_mem_data[31:16];
			4'b0011 : read_half_word <= raw_mem_data[15:0];
			default : read_half_word <= `ZeroWord;
		endcase
	end

	always @(*) begin : proc_read_mem_control
		if (rst == ~`RstEnable) begin
			case (opcode)
				`mips_lb  : data_to_reg <= {{24{read_byte[7]}}, read_byte};
				`mips_lh  : data_to_reg <= {{16{read_half_word[15]}}, read_half_word};
				`mips_lw  : data_to_reg <= raw_mem_data;
				`mips_lbu :	data_to_reg <= {24'b0, read_byte};
				`mips_lhu : data_to_reg <= {16'b0, read_half_word};
				default   : data_to_reg <= `ZeroWord;
			endcase
		end
		else data_to_reg <= `ZeroWord;
	end
endmodule