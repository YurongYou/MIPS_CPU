module HazardControl (
	input 						rst,
	input						ReadMem_EX,
	input[`RegAddrWidth-1:0]	raddr_1_ID,
	input[`RegAddrWidth-1:0]	raddr_2_ID,
	input[`RegAddrWidth-1:0]	target_EX,

	output reg					is_hold_IF,
	output reg					is_hold_IF_ID,
	output reg					is_zeros_ID_EX
);
	always @(*) begin : proc_hazard_control
		if (rst == ~`RstEnable) begin
			if ((ReadMem_EX == `ReadEnable) &&
				((raddr_1_ID == target_EX) ||
				 (raddr_2_ID == target_EX))) begin
				is_hold_IF <= `HoldEnable;
				is_hold_IF_ID <= `HoldEnable;
				is_zeros_ID_EX <= `RstEnable;
			end
		end
		else begin
			is_hold_IF <= ~`HoldEnable;
			is_hold_IF_ID <= ~`HoldEnable;
			is_zeros_ID_EX <= ~`RstEnable;
		end
	end
endmodule