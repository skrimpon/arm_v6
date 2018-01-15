`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the ALU datapath of the microprocessor.                                //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module alu_data_path(
	input CLK,
	input RST,
	
	input I,
	input S,
	input C,
	input WB,
	input IR4,
	input [1:0] SHOp,
	input [3:0] Rd,
	input [3:0] ALUOp,
	input [3:0] Rotate,
	input [4:0] Shift_amount,
	input [7:0] immediate,
	input [31:0] Rn,
	input [31:0] Rm,
	input [31:0] Rs,
	
	output ALU_S,
	output ALU_WB,
	output [31:0] ALU_Result,
	output [3:0] ALU_Address
	);
	
	wire [127:0] ALU_pipeline_reg_1;
	reg [74:0] ALU_pipeline_reg_2;
	reg [37:0] ALU_pipeline_reg_3;
//	ALU_pipeline_reg_1 <= {I, S, C, WB, IR4, SHOp, Rd, ALUOp, Rotate, Shift_amount, Immediate, Rn, Rm, Rs};
	
	assign ALU_pipeline_reg_1[127] = RST ? 0 : I;
	assign ALU_pipeline_reg_1[126] = RST ? 0 : S;
	assign ALU_pipeline_reg_1[125] = RST ? 0 : C;
	assign ALU_pipeline_reg_1[124] = RST ? 0 : WB;
	assign ALU_pipeline_reg_1[123] = RST ? 0 : IR4;
	assign ALU_pipeline_reg_1[122:121] = RST ? 0 : SHOp;
	assign ALU_pipeline_reg_1[120:117] = RST ? 0 : Rd;
	assign ALU_pipeline_reg_1[116:113] = RST ? 0 : ALUOp;
	assign ALU_pipeline_reg_1[112:109] = RST ? 0 : Rotate;
	assign ALU_pipeline_reg_1[108:104] = RST ? 0 : Shift_amount;
	assign ALU_pipeline_reg_1[103:96] = RST ? 0 : immediate;
	assign ALU_pipeline_reg_1[95:64] = RST ? 0 : Rn;
	assign ALU_pipeline_reg_1[63:32] = RST ? 0 : Rm;
	assign ALU_pipeline_reg_1[31:0] = RST ? 0 : Rs;
		
//	ALU_pipeline_reg_2 <= {S, C, WB, Rd, ALUOp, Oper1, Oper2};
	wire [31:0] Oper1 = ALU_pipeline_reg_1[95:64];
	wire [31:0] SH_VAL = ALU_pipeline_reg_1[127] ? {23'h0,ALU_pipeline_reg_1[103:96]} : ALU_pipeline_reg_1[63:32];
	wire [4:0] SH_AM = ALU_pipeline_reg_1[127] ? {1'b0, ALU_pipeline_reg_1[112:109]} : (ALU_pipeline_reg_1[123] ? ALU_pipeline_reg_1[4:0] : ALU_pipeline_reg_1[108:104]);
	
	reg [31:0] Oper2;
	wire [31:0] Oper2_LSL;
	wire [31:0] Oper2_LSR;
	wire [31:0] Oper2_ASR;
	wire [31:0] Oper2_ROR;

    barrel_shift_left LSL(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_LSL));
    barrel_shift_right_logical LSR(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_LSR));
    barrel_shift_right_arithmetical ASR(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_ASR));
    barrel_shift_right_cycle ROR(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_ROR));

	
	always @ ( * )
		begin
			case(ALU_pipeline_reg_1[122:121])
				2'h0: Oper2 = Oper2_LSL;
				2'h1: Oper2 = Oper2_LSR;
				2'h2: Oper2 = Oper2_ASR;
				2'h3: Oper2 = Oper2_ROR;
			endcase
		end
	
	always @ (posedge CLK)
		begin
			if(RST)
				begin
					ALU_pipeline_reg_2 <= 75'b0;
				end
			else
				begin
					ALU_pipeline_reg_2[74] <= ALU_pipeline_reg_1[126];
					ALU_pipeline_reg_2[73] <= ALU_pipeline_reg_1[125];
					ALU_pipeline_reg_2[72] <= ALU_pipeline_reg_1[124];
					ALU_pipeline_reg_2[71:68] <= ALU_pipeline_reg_1[120:117];
					ALU_pipeline_reg_2[67:64] <= ALU_pipeline_reg_1[116:113];
					ALU_pipeline_reg_2[63:32] <= Oper1;
					ALU_pipeline_reg_2[31:0] <= Oper2;
				end
		end	
		
//	ALU_pipeline_reg_2 <= {S, WB, Rd, Result};
        wire ADD_Cout;
	wire ADC_Cout;
        wire SUB_Cout;
        wire SDC_Cout;
        wire RSB_Cout;
        wire RSC_Cout;

        wire [31:0] ADD_res;
	wire [31:0] ADC_res;
        wire [31:0] SUB_res;
        wire [31:0] SDC_res;
        wire [31:0] RSB_res;
        wire [31:0] RSC_res;

	CLA_32bit ADD(.A(ALU_pipeline_reg_2[63:32]), .B(ALU_pipeline_reg_2[31:0]), .Cin(1'b0), .sel(1'b0), .S(ADD_res), .Cout(ADD_Cout));
        CLA_32bit ADC(.A(ALU_pipeline_reg_2[63:32]), .B(ALU_pipeline_reg_2[31:0]), .Cin(ALU_pipeline_reg_2[73]), .sel(1'b0), .S(ADC_res), .Cout(ADC_Cout));
        CLA_32bit SUB(.A(ALU_pipeline_reg_2[63:32]), .B(ALU_pipeline_reg_2[31:0]), .Cin(1'b0), .sel(1'b1), .S(SUB_res), .Cout(SUB_Cout));
        CLA_32bit SDC(.A(ALU_pipeline_reg_2[63:32]), .B(ALU_pipeline_reg_2[31:0]), .Cin(~ALU_pipeline_reg_2[73]), .sel(1'b1), .S(SDC_res), .Cout(SDC_Cout));
        CLA_32bit RSB(.A(ALU_pipeline_reg_2[31:0]), .B(ALU_pipeline_reg_2[63:32]), .Cin(1'b0), .sel(1'b1), .S(RSB_res), .Cout(RSB_Cout));
        CLA_32bit RSC(.A(ALU_pipeline_reg_2[31:0]), .B(ALU_pipeline_reg_2[63:32]), .Cin(~ALU_pipeline_reg_2[73]), .sel(1'b1), .S(RSC_res), .Cout(RSC_Cout));

	reg [31:0] ALU_Res;
	
	always @ ( * )
		begin
			case(ALU_pipeline_reg_2[67:64])
			4'b0100 : ALU_Res = ADD_res;	// ADD - Add
			4'b0101 : ALU_Res = ADC_res;	// ADC - Add with Carry
			4'b0010 : ALU_Res = SUB_res;	// SUB - Subtract
			4'b0110 : ALU_Res = SDC_res;	// SDC - Subtract with Carry
			4'b0011 : ALU_Res = RSB_res;	// RSB - Reverse Subtract
			4'b0111 : ALU_Res = RSC_res;	// RSC - Reverse Subtract with Carry
			4'b0000 : ALU_Res = ALU_pipeline_reg_2[63:32] & ALU_pipeline_reg_2[31:0];	// AND 
			4'b1100 : ALU_Res = ALU_pipeline_reg_2[63:32] | ALU_pipeline_reg_2[31:0];	// OR
			4'b0001 : ALU_Res = ALU_pipeline_reg_2[63:32] ^ ALU_pipeline_reg_2[31:0];	// XOR
			4'b1110 : ALU_Res = ALU_pipeline_reg_2[63:32] & (~ALU_pipeline_reg_2[31:0]);	// BIC
			4'b1101 : ALU_Res = ALU_pipeline_reg_2[31:0];					// MOV
			4'b1111 : ALU_Res = ~ALU_pipeline_reg_2[31:0];					// MVN
			endcase
		end
	
	always @ (posedge CLK)
		begin
			if(RST)
				begin
					ALU_pipeline_reg_3 <= 38'b0;
				end
			else
				begin
					ALU_pipeline_reg_3[37] <= ALU_pipeline_reg_2[74];
					ALU_pipeline_reg_3[36] <= ALU_pipeline_reg_2[72];
					ALU_pipeline_reg_3[35:32] <= ALU_pipeline_reg_2[71:68];
					ALU_pipeline_reg_3[31:0] <= ALU_Res;
				end
		end	
	
	assign ALU_S = ALU_pipeline_reg_3[37];
	assign ALU_WB = ALU_pipeline_reg_3[36];
	assign ALU_Address = ALU_pipeline_reg_3[35:32];
	assign ALU_Result = ALU_pipeline_reg_3[31:0];
	
endmodule
