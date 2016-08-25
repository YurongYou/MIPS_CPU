module IF_ID(clk, rst, is_hold, pc_plus4_IF, inst_IF, pc_plus4_ID, inst_ID);

	input clk;
	input rst;
	input is_hold;

	input[`InstAddrWidth-1:0] pc_plus4_IF;
	input[`InstDataWidth-1:0] inst_IF;

	output[`InstAddrWidth-1:0] pc_plus4_ID;
	output[`InstDataWidth-1:0] inst_ID;

	dffe #(.data_width(`InstAddrWidth)) pc_holder(clk, rst, is_hold, pc_plus4_IF, pc_plus4_ID);
	dffe #(.data_width(`InstDataWidth)) inst_holder(clk, rst, is_hold, inst_IF, inst_ID);

endmodule // IF_ID