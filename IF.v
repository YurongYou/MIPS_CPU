module IF (

	input 						clk,
	input 						rst,
	input						is_hold,
	input						is_branch,
	input[`InstAddrWidth-1:0]	branch_address,
	output reg					ce,
	output[`InstAddrWidth-1:0]	pc,				// connect to Instruction ROM
	output[`InstAddrWidth-1:0]	pc_plus4		// connect to IF_ID
);

	wire[`InstAddrWidth-1:0]	next_pc;
	assign pc_plus4 = pc + 4;

	dffe #(.data_width(`InstAddrWidth), .initial_value(-4)) pc_reg(clk, rst, is_hold, next_pc, pc);
	mux2x1 #(.data_width(`InstAddrWidth)) mux(.in_0(pc_plus4), .in_1(branch_address), .slct(is_branch), .out(next_pc));

	always @(posedge clk) begin : proc_ceResst
		if (rst == `RstEnable)
			ce <= ~`ChipEnable;
		else
			ce <= `ChipEnable;
	end

endmodule