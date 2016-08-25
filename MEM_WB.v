module MEM_WB (clk, rst, is_hold, target_MEM, ALU_data_MEM, MEM_data_out_MEM, we_hi_MEM, we_lo_MEM, hi_MEM, lo_MEM, WriteReg_MEM, MemOrAlu_MEM,
	target_WB, ALU_data_WB, MEM_data_out_WB, we_hi_WB, we_lo_WB, hi_WB, lo_WB, WriteReg_WB, MemOrAlu_WB
	);
	input clk;
	input rst;
	input is_hold;

	input[`RegAddrWidth-1:0]		target_MEM;
	input[`RegDataWidth-1:0]		ALU_data_MEM;
	input[`RegDataWidth-1:0]		MEM_data_out_MEM;
	input							we_hi_MEM;
	input							we_lo_MEM;
	input[`RegDataWidth-1:0]		hi_MEM;
	input[`RegDataWidth-1:0]		lo_MEM;
	input							WriteReg_MEM;
	input							MemOrAlu_MEM;

	output[`RegAddrWidth-1:0]		target_WB;
	output[`RegDataWidth-1:0]		ALU_data_WB;
	output[`RegDataWidth-1:0]		MEM_data_out_WB;
	output							we_hi_WB;
	output							we_lo_WB;
	output[`RegDataWidth-1:0]		hi_WB;
	output[`RegDataWidth-1:0]		lo_WB;
	output							WriteReg_WB;
	output							MemOrAlu_WB;

	dffe #(.data_width(`RegAddrWidth)) target_holder(clk, rst, is_hold, target_MEM, target_WB);
	dffe #(.data_width(`RegDataWidth)) ALU_data_holder(clk, rst, is_hold, ALU_data_MEM, ALU_data_WB);
	dffe #(.data_width(`RegDataWidth)) MEM_data_out_holder(clk, rst, is_hold, MEM_data_out_MEM, MEM_data_out_WB);
	dffe we_hi_holder(clk, rst, is_hold, we_hi_MEM, we_hi_WB);
	dffe we_lo_holder(clk, rst, is_hold, we_lo_MEM, we_lo_WB);
	dffe #(.data_width(`RegDataWidth)) hi_holder(clk, rst, is_hold, hi_MEM, hi_WB);
	dffe #(.data_width(`RegDataWidth)) lo_holder(clk, rst, is_hold, lo_MEM, lo_WB);
	dffe WriteReg_holder(clk, rst, is_hold, WriteReg_MEM, WriteReg_WB);
	dffe MemOrAlu_holder(clk, rst, is_hold, MemOrAlu_MEM, MemOrAlu_WB);

endmodule