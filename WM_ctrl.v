module WM_ctrl (
	input 							rst,
	input[`RegDataWidth-1:0] 		raw_reg_data,
	input[`OpcodeWidth-1:0]			opcode,

	output reg[`RegDataWidth-1:0]	data_to_mem
);
	always @(*) begin : proc_write_mem_control
		if (rst == ~`RstEnable) begin
			case (opcode)
				`mips_sb : data_to_mem <= {4{raw_reg_data[`ByteBus]}};
				`mips_sh : data_to_mem <= {2{raw_reg_data[`HalfWordBus]}};
				`mips_sw : data_to_mem <= raw_reg_data;
				default : data_to_mem <= `ZeroWord;
			endcase
		end
		else data_to_mem <= `ZeroWord;
	end
endmodule