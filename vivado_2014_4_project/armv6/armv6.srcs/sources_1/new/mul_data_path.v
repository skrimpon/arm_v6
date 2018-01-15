`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the MUL datapath of the microprocessor.                                //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module mul_data_path(
	input CLK,
	input RST,
	
	input A,
	input S,
	input WB,
	input [31:0] Rn,
	input [31:0] Rm,
	input [31:0] Rs,
	input [3:0] Rd,
	
	output MUL_S,
	output MUL_WB,
	output [63:0] MUL_Result,
	output [3:0] MUL_Address
	);
	
	wire [102:0] MUL_pipeline_reg_1;
	reg  [102:0] MUL_pipeline_reg_2;
	reg  [69:0]  MUL_pipeline_reg_3;
	
//	MUL_pipeline_reg_1 <= {A, S, WB, Rn, Rm, Rs, Rd};
	
	assign MUL_pipeline_reg_1[102] = RST ? 0 : A;
	assign MUL_pipeline_reg_1[101] = RST ? 0 : S;
	assign MUL_pipeline_reg_1[100] = RST ? 0 : WB;
	assign MUL_pipeline_reg_1[99:68] = RST ? 0 : Rn;
	assign MUL_pipeline_reg_1[67:36] = RST ? 0 : Rm;
	assign MUL_pipeline_reg_1[35:4] = RST ? 0 : Rs;
	assign MUL_pipeline_reg_1[3:0] = RST ? 0 : Rd;
	
//	MUL_pipeline_reg_2 <= {A, S, WB, Rn, MUL_Res, Rd};
        wire [63:0] MUL_Res;        
    booth_multiplication mul(
        .A(MUL_pipeline_reg_1[67:36]),
        .B(MUL_pipeline_reg_1[35:4]),
        .hilo(MUL_Res)
    );

	always @ (posedge CLK)
		begin
			if(RST)
				begin
					MUL_pipeline_reg_2 <= 103'b0;
				end
			else
				begin
					MUL_pipeline_reg_2[102] <= MUL_pipeline_reg_1[102];
					MUL_pipeline_reg_2[101] <= MUL_pipeline_reg_1[101];
					MUL_pipeline_reg_2[100] <= MUL_pipeline_reg_1[100];
					MUL_pipeline_reg_2[99:68] <= MUL_pipeline_reg_1[99:68];
					MUL_pipeline_reg_2[67:4] <= MUL_Res;
					MUL_pipeline_reg_2[3:0] <= MUL_pipeline_reg_1[3:0];
				end
		end
		
//	MUL_pipeline_reg_3 <= {S, WB, Result, Rd};
	wire [63:0] MAC_Res;
	CLA_64bit MAC(
			.A(MUL_pipeline_reg_2[67:4]),
			.B({32'b0, MUL_pipeline_reg_2[99:68]}),
			.Cin(1'b0),
			.S(MAC_Res),
			.PG(PG),
			.GG(GG),
			.C32(C32)
			);

	wire [63:0] Result = MUL_pipeline_reg_2[102] ? MAC_Res : MUL_pipeline_reg_2[67:4];
	
	always @ (posedge CLK)
		begin
			if(RST)
				begin
					MUL_pipeline_reg_3 <= 70'b0;
				end
			else
				begin
					MUL_pipeline_reg_3[69] <= MUL_pipeline_reg_2[101];
					MUL_pipeline_reg_3[68] <= MUL_pipeline_reg_2[100];
					MUL_pipeline_reg_3[67:4] <= Result;
					MUL_pipeline_reg_3[3:0] <= MUL_pipeline_reg_2[3:0];
				end
		end
	
	assign MUL_S = MUL_pipeline_reg_3[69];
	assign MUL_WB = MUL_pipeline_reg_3[68];
	assign MUL_Result = MUL_pipeline_reg_3[67:4];
	assign MUL_Address = MUL_pipeline_reg_3[3:0];
	
endmodule
