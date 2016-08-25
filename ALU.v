module ALU (
	input rst,
	input[`RegDataWidth-1:0] 		srcA,
	input[`RegDataWidth-1:0] 		srcB,
	input[1:0] 						AluType,
	input[1:0] 						AluOp,
	input[`RegDataWidth-1:0] 		hi_in,
	input[`RegDataWidth-1:0] 		lo_in,

	output reg	   					is_Overflow,
	output reg[`RegDataWidth-1:0] 	data_out,
	output 							we_hi,
	output 							we_lo,
	output[`RegDataWidth-1:0] 		hi_out,
	output[`RegDataWidth-1:0] 		lo_out
);
	// TODO
	always @(*) begin : proc_alu
		if(rst == ~`RstEnable) begin
			case (AluType)
				`ALU_ADD_SUB: begin
					case (AluOp)
						`Addu: begin
							data_out <= srcA + srcB;
							is_Overflow <= ~`Overflow;
						end
						`Add: begin
							data_out <= srcA + srcB;
							if ((data_out[`RegDataWidth-1] ^ srcA[`RegDataWidth-1]) &&
								(srcA[`RegDataWidth-1] ~^ srcB[`RegDataWidth-1]))
								is_Overflow <= `Overflow;
							else is_Overflow <= ~`Overflow;
						end
						`Subu: begin
							data_out <= srcA - srcB;
							is_Overflow <= ~`Overflow;
						end
						`Sub: begin
							data_out <= srcA - srcB;
							if ((data_out[`RegDataWidth-1] ^ srcA[`RegDataWidth-1]) &&
								(srcA[`RegDataWidth-1] ^ srcB[`RegDataWidth-1]))
								is_Overflow <= `Overflow;
							else is_Overflow <= ~`Overflow;
						end
						default: begin
						end
					endcase
				end
				`ALU_MUL_DIV: begin
					case (AluOp)

						default: begin
						end
					endcase
				end
				`ALU_LOGIC: begin
					is_Overflow <= ~`Overflow;
					case (AluOp)
						`And: data_out <= srcA & srcB;
						`Or: data_out <= srcA | srcB;
						`Xor: data_out <= srcA ^ srcB;
						`Nor: data_out <= ~(srcA | srcB);
						default: begin
						end
					endcase
				end
				`ALU_SHIFT: begin
					is_Overflow <= ~`Overflow;
					case (AluOp)
						`Sll: data_out <= srcB << srcA[4:0];
						`Srl: data_out <= srcB >> srcA[4:0];
						`Sra: data_out <= ( {`RegDataWidth{srcB[`RegDataWidth-1]}} << (6'd32 - {1'b0, srcA[4:0]}) )
						| (srcB >> srcA[4:0]);
						default: begin
						end
					endcase
				end
				default: begin
				end
			endcase
		end
		else data_out <= `ZeroWord;
	end
endmodule