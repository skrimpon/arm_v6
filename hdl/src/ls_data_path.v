`timescale 1ns / 1ps
module ls_data_path(
	input CLK,
	input RST,
	
	input I,
	input P,
	input U,
	input B,
	input W,
	input L,
	input [1:0] SH_OP,
	input [3:0] Rn_addr,
	input [3:0] Rd_addr,
	input [4:0] SH_amount,
	input [11:0] offset,
	input [31:0] Rn,
	input [31:0] Rd,
	input [31:0] Rm,
	
	output L_EN,
	output WB_EN,
	output [3:0] WB_Addr,
	output [3:0] L_Addr,
	output [31:0] WB_data,
	output [31:0] L_data
	);
	
	wire [128:0] LS_pipeline_reg_1;
    reg  [106:0] LS_pipeline_reg_2;
    reg  [106:0] LS_pipeline_reg_3;

    reg [31:0] data_mem [1023:0];         // Data Memory    

    initial begin
        $readmemb("data.bin", data_mem);
    end

	assign LS_pipeline_reg_1[    128] = RST ? 0 : I;
	assign LS_pipeline_reg_1[    127] = RST ? 0 : P;
	assign LS_pipeline_reg_1[    126] = RST ? 0 : U;
	assign LS_pipeline_reg_1[    125] = RST ? 0 : B;
	assign LS_pipeline_reg_1[    124] = RST ? 0 : W;
	assign LS_pipeline_reg_1[    123] = RST ? 0 : L;
	assign LS_pipeline_reg_1[122:121] = RST ? 0 : SH_OP;
	assign LS_pipeline_reg_1[120:117] = RST ? 0 : Rn_addr;
	assign LS_pipeline_reg_1[116:113] = RST ? 0 : Rd_addr;
	assign LS_pipeline_reg_1[112:108] = RST ? 0 : SH_amount;
	assign LS_pipeline_reg_1[107: 96] = RST ? 0 : offset;
	assign LS_pipeline_reg_1[ 95: 64] = RST ? 0 : Rn;
	assign LS_pipeline_reg_1[ 63: 32] = RST ? 0 : Rd;
	assign LS_pipeline_reg_1[ 31:  0] = RST ? 0 : Rm;

    wire [31:0] SH_VAL = LS_pipeline_reg_1[ 31:  0];
    wire [ 4:0] SH_AM  = LS_pipeline_reg_1[112:108];

    reg  [31:0] Oper2;
    wire [31:0] Oper2_LSL;
    wire [31:0] Oper2_LSR;
    wire [31:0] Oper2_ASR;
    wire [31:0] Oper2_ROR;

    barrel_shift_left LSL(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_LSL));
    barrel_shift_right_logical LSR(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_LSR));
    barrel_shift_right_arithmetical ASR(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_ASR));
    barrel_shift_right_cycle ROR(.unshifted_data(SH_VAL), .shift(SH_AM), .shifted_data(Oper2_ROR));


    always @ ( * ) begin
        case(LS_pipeline_reg_1[122:121])
            2'h0: Oper2 = Oper2_LSL;
            2'h1: Oper2 = Oper2_LSR;
            2'h2: Oper2 = Oper2_ASR;
            2'h3: Oper2 = Oper2_ROR;
        endcase
    end
	
	wire [31:0] Address_offset = LS_pipeline_reg_1[128] ? Oper2 : {20'h0,LS_pipeline_reg_1[107:96]};
	wire [31:0] Address_ADD;
	wire [31:0] Address_SUB;
	wire [ 1:0] C;

    CLA_32bit ADD_SH(.A(LS_pipeline_reg_1[95:64]), .B(Address_offset), .Cin(1'b0), .sel(1'b0), .S(Address_ADD), .Cout(C[0]));
	CLA_32bit SUB_SH(.A(LS_pipeline_reg_1[95:64]), .B(Address_offset), .Cin(1'b0), .sel(1'b1), .S(Address_SUB), .Cout(C[1]));

	wire [31:0] Post_Index_Address = LS_pipeline_reg_1[126] ? Address_ADD : Address_SUB; 
	wire [31:0] MEM_Address = LS_pipeline_reg_1[127] ? Post_Index_Address : LS_pipeline_reg_1[95:64];

	always @ ( posedge CLK ) begin
        if(RST)
            LS_pipeline_reg_2 <= 107'b0;
        else begin
            LS_pipeline_reg_2[106] <= LS_pipeline_reg_1[125];
            LS_pipeline_reg_2[105] <= LS_pipeline_reg_1[124];
            LS_pipeline_reg_2[104] <= LS_pipeline_reg_1[123];
            LS_pipeline_reg_2[103:100] <= LS_pipeline_reg_1[120:117];
            LS_pipeline_reg_2[99:96] <= LS_pipeline_reg_1[116:113];
            LS_pipeline_reg_2[95:64] <= MEM_Address;
            LS_pipeline_reg_2[63:32] <= Post_Index_Address;
            LS_pipeline_reg_2[31:0] <= LS_pipeline_reg_1[63:32];
        end
    end

	always @ (posedge CLK) begin
        if (~LS_pipeline_reg_2[104]) begin
            if(LS_pipeline_reg_2[106])
                data_mem[LS_pipeline_reg_2[95:64]] <= (data_mem[LS_pipeline_reg_2[95:64]] & 32'hffffff00) | (LS_pipeline_reg_2[31:0] & 32'hff);
            else
                data_mem[LS_pipeline_reg_2[95:64]] <= LS_pipeline_reg_2[31:0];
        end
    end
	
	wire [31:0] MEM_data = LS_pipeline_reg_2[106] ? (data_mem[LS_pipeline_reg_2[95:64]] & 32'hff) : data_mem[LS_pipeline_reg_2[95:64]];
	
	always @ (posedge CLK) begin
        if(RST)
            LS_pipeline_reg_3 <= 74'b0;
        else begin
            LS_pipeline_reg_3[73] <= LS_pipeline_reg_2[105];
            LS_pipeline_reg_3[72] <= LS_pipeline_reg_2[104];
            LS_pipeline_reg_3[71:68] <= LS_pipeline_reg_2[103:100];
            LS_pipeline_reg_3[67:64] <= LS_pipeline_reg_2[99:96];
            LS_pipeline_reg_3[63:32] <= MEM_data;
            LS_pipeline_reg_3[31:0] <= LS_pipeline_reg_2[63:32];
        end
    end
    
	assign WB_EN   = LS_pipeline_reg_3[73];
	assign WB_addr = LS_pipeline_reg_3[71:68]; 
	assign WB_data = LS_pipeline_reg_3[31:0];

	assign L_EN   = LS_pipeline_reg_3[72];
	assign L_addr = LS_pipeline_reg_3[67:64];
	assign L_data = LS_pipeline_reg_3[63:32];
endmodule
