`timescale 1ns / 1ps
module div_data_path(
	input CLK,
	input RST,
	
	input A,
	input S,
	input WB,
	input [31:0] Rn,
	input [31:0] Rm,
	input [31:0] Rs,
	input [3:0] Rd,
	
	output DIV_S,
	output DIV_WB,
	output [63:0] DIV_Result,
	output [3:0] DIV_Address
	);
	
	wire [102:0] DIV_pipeline_reg_1;
	reg  [102:0] DIV_pipeline_reg_2;
	reg  [ 69:0] DIV_pipeline_reg_3;
	
//	DIV_pipeline_reg_1 <= {A, S, WB, Rn, Rm, Rs, Rd};
	
	assign DIV_pipeline_reg_1[102]   = RST ? 0 : A;
	assign DIV_pipeline_reg_1[101]   = RST ? 0 : S;
	assign DIV_pipeline_reg_1[100]   = RST ? 0 : WB;
	assign DIV_pipeline_reg_1[99:68] = RST ? 0 : Rn;
	assign DIV_pipeline_reg_1[67:36] = RST ? 0 : Rm;
	assign DIV_pipeline_reg_1[35:4]  = RST ? 0 : Rs;
	assign DIV_pipeline_reg_1[3:0]   = RST ? 0 : Rd;
	
//	DIV_pipeline_reg_2 <= {A, S, WB, Rn, DIV_Res, Rd};
    wire [31:0] R;
	wire [31:0] Q;        
    non_restoring_division division(
        .M(DIV_pipeline_reg_1[35:4]),
        .D(DIV_pipeline_reg_1[67:36]),
        .R(R),
        .Q(Q)
    );

	always @ (posedge CLK)
		begin
			if(RST)
				begin
					DIV_pipeline_reg_2 <= 103'b0;
				end
			else
				begin
					DIV_pipeline_reg_2[102] <= DIV_pipeline_reg_1[102];
					DIV_pipeline_reg_2[101] <= DIV_pipeline_reg_1[101];
					DIV_pipeline_reg_2[100] <= DIV_pipeline_reg_1[100];
					DIV_pipeline_reg_2[99:68] <= DIV_pipeline_reg_1[99:68];
					DIV_pipeline_reg_2[67:4] <= {R, Q};
					DIV_pipeline_reg_2[3:0] <= DIV_pipeline_reg_1[3:0];
				end
		end
		
//	DIV_pipeline_reg_3 <= {S, WB, Result, Rd};
	wire [63:0] DAC_Res;
	CLA_64bit DAC(
			.A(DIV_pipeline_reg_2[67:4]),
			.B({32'b0, DIV_pipeline_reg_2[99:68]}),
			.Cin(1'b0),
			.S(DAC_Res),
			.PG(PG),
			.GG(GG),
			.C32(C32)
			);

	wire [63:0] Result = DIV_pipeline_reg_2[102] ? DAC_Res : DIV_pipeline_reg_2[67:4];
	
	always @ (posedge CLK) begin
        if(RST)
                DIV_pipeline_reg_3 <= 70'b0;
        else begin
            DIV_pipeline_reg_3[69] <= DIV_pipeline_reg_2[101];
            DIV_pipeline_reg_3[68] <= DIV_pipeline_reg_2[100];
            DIV_pipeline_reg_3[67:4] <= Result;
            DIV_pipeline_reg_3[3:0] <= DIV_pipeline_reg_2[3:0];
        end
    end
	
	assign DIV_S = DIV_pipeline_reg_3[69];
	assign DIV_WB = DIV_pipeline_reg_3[68];
	assign DIV_Result = DIV_pipeline_reg_3[67:4];
	assign DIV_Address = DIV_pipeline_reg_3[3:0];
	
endmodule
