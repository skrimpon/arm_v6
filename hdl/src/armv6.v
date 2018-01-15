`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the top module of the microprocessor.                                  //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module armv6(
    input CLK,
    input RST
    );
// Memory
reg  [ 31:0] instruction_mem [  31:0]; // Instruction Memory
reg  [ 31:0] data_mem        [1023:0]; // Data Memory

reg  [  4:0] CTRL_REG;                 // Control register
reg  [ 31:0] PC;                       // Program Counter
reg  [ 63:0] instruction_fetch_reg;    // Instruction Fetch Pipeline Register
reg  [180:0] instruction_iss_reg;      // Instruction Issue Pipeline Register
    
wire       WB;
wire       EXEC;
wire       RD_CTRL_C;
wire [1:0] RD_CTRL_B;
wire [1:0] RD_CTRL_A;
wire [1:0] WR_CTRL;
wire [2:0] ISS;


wire        WB_S       = (ALU_WB & ALU_S) | (MUL_WB & MUL_S) | (DIV_WB & DIV_S);
wire        WB_WR      = ALU_WB | MUL_WB | DIV_WB | LS_WB_EN | LS_L_EN;
wire [31:0] WB_Result  = ({32{ALU_WB}} & ALU_Result) | ({32{MUL_WB}} & MUL_Result) | ({32{DIV_WB}} & DIV_Result) | ({32{LS_WB_EN}} & LS_WB_data) | ({32{LS_L_EN}} & LS_L_data);
wire [ 3:0] WB_Address = ({4{ALU_WB}} & ALU_Address) | ({4{MUL_WB}} & MUL_Address) | ({4{DIV_WB}} & DIV_Address) | ({4{LS_WB_EN}} & LS_WB_addr) | ({4{LS_L_EN}} & LS_L_addr);

initial begin
    $readmemb("instructions.bin", instruction_mem);
end

always @ (posedge CLK) begin
    if(RST)
        PC <= 32'h0;
    else if(!STALL)
        PC <= (instruction_iss_reg[180]) ? instruction_iss_reg[179:148] : PC + 1;
end
    
always @ (posedge CLK) begin
    if(RST || instruction_iss_reg[180])
        instruction_fetch_reg <= 64'h0;
    else if (!STALL) begin
        instruction_fetch_reg[63:32] <= PC + 1;
        instruction_fetch_reg[31:0] <= instruction_mem[PC];
    end
end

always @ (posedge CLK) begin
    if (RST)
        CTRL_REG <= 5'h0;
    else if (WB_S)
        CTRL_REG <= CTRL_REG + 1;
end

control_unit armv6_control_unit(
    .A        (instruction_fetch_reg[21]),
    .I        (instruction_fetch_reg[25]),
    .K        (instruction_fetch_reg[24]),
    .L        (instruction_fetch_reg[20]),
    .IR4      (instruction_fetch_reg[4]),
    .CONDITION(instruction_fetch_reg[31:28]),
    .CTRL_REG (CTRL_REG[3:0]),
    .OPCODE   ({instruction_fetch_reg[27:26], instruction_fetch_reg[7:4]}),
    .WB       (WB),
    .EXEC     (EXEC),
    .RD_CTRL_C(RD_CTRL_C),
    .RD_CTRL_B(RD_CTRL_B),
    .RD_CTRL_A(RD_CTRL_A),
    .WR_CTRL  (WR_CTRL),
    .ISS      (ISS)
);

wire STALL;
wire CLEAR = (RST || instruction_iss_reg[180] || ~EXEC);

wire [3:0] read_address_1 = RD_CTRL_A[1] ? instruction_fetch_reg[15:12] : (RD_CTRL_A[0] ? instruction_fetch_reg[19:16] : 4'b0);
wire [3:0] read_address_2 = RD_CTRL_B[1] ? instruction_fetch_reg[11: 8] : (RD_CTRL_B[0] ? instruction_fetch_reg[15:12] : 4'b0);
wire [3:0] read_address_3 = RD_CTRL_C    ? instruction_fetch_reg[ 3: 0] : 4'b0;
wire [3:0] write_address  = WR_CTRL[1]   ? instruction_fetch_reg[15:12] : (WR_CTRL[0]   ? instruction_fetch_reg[19:16] : 4'b0);

wire [31:0] read_data_1;
wire [31:0] read_data_2;
wire [31:0] read_data_3;

wire [31:0] Branch_PC;

register_file armv6_register_file(
    .CLK           (CLK),           
    .RST           (RST),           
    .WRITE         (WB_WR),         
    .processor_mode(CTRL_REG[4]),   
    .read_address_1(read_address_1),
    .read_address_2(read_address_2),
    .read_address_3(read_address_3),
    .write_address (WB_Address),    
    .write_data    (WB_Result),     
    .read_data_1   (read_data_1),   
    .read_data_2   (read_data_2),   
    .read_data_3   (read_data_3)    
);

CLA_32bit armv6_branch_unit(.A(instruction_fetch_reg[63:32]), .B({8'b0,instruction_fetch_reg[23:0]}), .Cin(1'b0), .sel(1'b0), .S(Branch_PC), .Cout(Branch_C));

hazzard_detection_unit armv6_hazzard_detection_unit(
    .CLK         (CLK),
    .RST         (RST),
    .WR          (WB),
    .WB_WR       (WB_WR),
    .RD_Address_A(read_address_1),
    .RD_Address_B(read_address_2),
    .RD_Address_C(read_address_3),
    .WR_Address  (write_address),
    .WB_Address  (WB_Address),
    .STALL       (STALL)
);

always @ (posedge CLK) begin
    if(CLEAR)
        instruction_iss_reg          <= 181'h0;
    else if(!STALL) begin
        instruction_iss_reg[180    ] <= (ISS == 3'b100) ? 1'b1 : 1'b0;
        instruction_iss_reg[179:148] <= Branch_PC;
        instruction_iss_reg[147:144] <= read_address_1;
        instruction_iss_reg[143:140] <= read_address_2;
        instruction_iss_reg[139:136] <= read_address_3;
        instruction_iss_reg[135:132] <= write_address;
        instruction_iss_reg[131    ] <= WB;
        instruction_iss_reg[130    ] <= CTRL_REG[0];
        instruction_iss_reg[129    ] <= RD_CTRL_C;
        instruction_iss_reg[128:126] <= ISS;
        instruction_iss_reg[125:124] <= RD_CTRL_B;
        instruction_iss_reg[123:122] <= RD_CTRL_A;
        instruction_iss_reg[121: 90] <= read_data_1;
        instruction_iss_reg[ 89: 58] <= read_data_2;
        instruction_iss_reg[ 57: 26] <= read_data_3;
        instruction_iss_reg[ 25:  0] <= instruction_fetch_reg[25:0];
    end
end

wire [2:0] ISS_PATH = instruction_iss_reg[128:126];
wire FWD_A = (instruction_iss_reg[147:144] == WB_Address);
wire FWD_B = (instruction_iss_reg[143:140] == WB_Address);
wire FWD_C = (instruction_iss_reg[139:136] == WB_Address);


wire        ALU_S;
wire        ALU_WB;
wire [31:0] ALU_Result;
wire [ 3:0] ALU_Address;
wire        ALU_I            = (ISS_PATH == 3'b0) ? instruction_iss_reg[   25]                        :  1'b0;
wire        ALUS             = (ISS_PATH == 3'b0) ? instruction_iss_reg[   20]                        :  1'b0;
wire        ALU_C            = (ISS_PATH == 3'b0) ? instruction_iss_reg[  130]                        :  1'b0;
wire        ALUWB            = (ISS_PATH == 3'b0) ? instruction_iss_reg[  131]                        :  1'b0;
wire        ALU_IR4          = (ISS_PATH == 3'b0) ? instruction_iss_reg[    4]                        :  1'b0;
wire [ 1:0] ALU_SHOp         = (ISS_PATH == 3'b0) ? instruction_iss_reg[ 6: 5]                        :  2'b0;
wire [ 3:0] ALU_Rd           = (ISS_PATH == 3'b0) ? instruction_iss_reg[15:12]                        :  4'b0;
wire [ 3:0] ALU_ALUOp        = (ISS_PATH == 3'b0) ? instruction_iss_reg[24:21]                        :  4'b0;
wire [ 3:0] ALU_Rotate       = (ISS_PATH == 3'b0) ? instruction_iss_reg[11: 8]                        :  4'b0;
wire [ 4:0] ALU_Shift_amount = (ISS_PATH == 3'b0) ? instruction_iss_reg[11: 7]                        :  5'b0;
wire [ 7:0] ALU_immediate    = (ISS_PATH == 3'b0) ? instruction_iss_reg[ 7: 0]                        :  8'b0;
wire [31:0] ALU_Rn           = (ISS_PATH == 3'b0) ? (FWD_A ? WB_Result : instruction_iss_reg[121:90]) : 32'b0;
wire [31:0] ALU_Rm           = (ISS_PATH == 3'b0) ? (FWD_C ? WB_Result : instruction_iss_reg[57:26])  : 32'b0;
wire [31:0] ALU_Rs           = (ISS_PATH == 3'b0) ? (FWD_B ? WB_Result : instruction_iss_reg[89:58])  : 32'b0;

alu_data_path armv6_alu_data_path(
    .CLK(CLK),
    .RST(RST),
    
    .I(ALU_I),
    .S(ALUS),
    .C(ALU_C),
    .WB(ALUWB),
    .IR4(ALU_IR4),
    .SHOp(ALU_SHOp),
    .Rd(ALU_Rd),
    .ALUOp(ALU_ALUOp),
    .Rotate(ALU_Rotate),
    .Shift_amount(ALU_Shift_amount),
    .immediate(ALU_immediate),
    .Rn(ALU_Rn),
    .Rm(ALU_Rm),
    .Rs(ALU_Rs),
    
    .ALU_S(ALU_S),
    .ALU_WB(ALU_WB),
    .ALU_Result(ALU_Result),
    .ALU_Address(ALU_Address)
);

wire        MUL_S;
wire        MUL_WB;
wire [63:0] MUL_Result;
wire [ 3:0] MUL_Address;
wire        MUL_A  = (ISS_PATH == 3'b001) ? instruction_iss_reg[    21] :  1'b0;
wire        MULS   = (ISS_PATH == 3'b001) ? instruction_iss_reg[    20] :  1'b0;
wire        MULWB  = (ISS_PATH == 3'b001) ? instruction_iss_reg[   131] :  1'b0;
wire [31:0] MUL_Rn = (ISS_PATH == 3'b001) ? instruction_iss_reg[121:90] : 31'b0;
wire [31:0] MUL_Rm = (ISS_PATH == 3'b001) ? instruction_iss_reg[ 89:58] : 31'b0;
wire [31:0] MUL_Rs = (ISS_PATH == 3'b001) ? instruction_iss_reg[ 57:26] : 31'b0;
wire [ 3:0] MUL_Rd = (ISS_PATH == 3'b001) ? instruction_iss_reg[ 19:16] :  4'b0;

mul_data_path armv6_mul_data_path(
    .CLK(CLK),
    .RST(RST),
    
    .A(MUL_A),
    .S(MULS),
    .WB(MULWB),
    .Rn(MUL_Rn),
    .Rm(MUL_Rm),
    .Rs(MUL_Rs),
    .Rd(MUL_Rd),
    
    .MUL_S(MUL_S),
    .MUL_WB(MUL_WB),
    .MUL_Result(MUL_Result),
    .MUL_Address(MUL_Address)
);

wire        DIV_S;
wire        DIV_WB;
wire [63:0] DIV_Result;
wire [ 3:0] DIV_Address;
wire        DIV_A  = (ISS_PATH == 3'b010) ? instruction_iss_reg[    21] :  1'b0;
wire        DIVS   = (ISS_PATH == 3'b010) ? instruction_iss_reg[    20] :  1'b0;
wire        DIVWB  = (ISS_PATH == 3'b010) ? instruction_iss_reg[   131] :  1'b0;
wire [31:0] DIV_Rn = (ISS_PATH == 3'b010) ? instruction_iss_reg[121:90] : 31'b0;
wire [31:0] DIV_Rm = (ISS_PATH == 3'b010) ? instruction_iss_reg[ 89:58] : 31'b0;
wire [31:0] DIV_Rs = (ISS_PATH == 3'b010) ? instruction_iss_reg[ 57:26] : 31'b0;
wire [ 3:0] DIV_Rd = (ISS_PATH == 3'b010) ? instruction_iss_reg[ 19:16] :  4'b0;

div_data_path armv6_div_data_path(
    .CLK(CLK),
    .RST(RST),
    
    .A(DIV_A),
    .S(DIVS),
    .WB(DIVWB),
    .Rn(DIV_Rn),
    .Rm(DIV_Rm),
    .Rs(DIV_Rs),
    .Rd(DIV_Rd),
    
    .DIV_S(DIV_S),
    .DIV_WB(DIV_WB),
    .DIV_Result(DIV_Result),
    .DIV_Address(DIV_Address)
);


wire        LS_L_EN;
wire        LS_WB_EN;
wire [ 3:0] LS_L_addr;
wire [ 3:0] LS_WB_addr;
wire [31:0] LS_L_data;
wire [31:0] LS_WB_data;
wire        LS_I      = (ISS_PATH == 3'b011) ? instruction_iss_reg[    25] :  1'b0;
wire        LS_P      = (ISS_PATH == 3'b011) ? instruction_iss_reg[    24] :  1'b0;
wire        LS_U      = (ISS_PATH == 3'b011) ? instruction_iss_reg[    23] :  1'b0;
wire        LS_B      = (ISS_PATH == 3'b011) ? instruction_iss_reg[    22] :  1'b0;
wire        LS_W      = (ISS_PATH == 3'b011) ? instruction_iss_reg[    21] :  1'b0;
wire        LS_L      = (ISS_PATH == 3'b011) ? instruction_iss_reg[    20] :  1'b0;
wire [ 1:0] LS_SH_OP  = (ISS_PATH == 3'b011) ? instruction_iss_reg[  6: 5] :  2'b0;
wire [ 3:0] LS_Rn     = (ISS_PATH == 3'b011) ? instruction_iss_reg[ 19:16] :  4'b0;
wire [ 3:0] LS_Rd     = (ISS_PATH == 3'b011) ? instruction_iss_reg[ 15:12] :  4'b0;
wire [ 4:0] LS_SH_AM  = (ISS_PATH == 3'b011) ? instruction_iss_reg[ 11: 7] :  5'b0;
wire [11:0] LS_offset = (ISS_PATH == 3'b011) ? instruction_iss_reg[ 11: 0] : 12'b0;
wire [31:0] LS_Rn_A   = (ISS_PATH == 3'b011) ? instruction_iss_reg[121:90] : 32'b0;
wire [31:0] LS_Rd_B   = (ISS_PATH == 3'b011) ? instruction_iss_reg[ 89:58] : 32'b0;
wire [31:0] LS_Rm_C   = (ISS_PATH == 3'b011) ? instruction_iss_reg[ 57:26] : 32'b0;

ls_data_path armv6_ls_data_path(
    .CLK(CLK),
    .RST(RST),
    
    .I(LS_I),
    .P(LS_P),
    .U(LS_U),
    .B(LS_B),
    .W(LS_W),
    .L(LS_L),
    .SH_OP(LS_SH_OP),
    .Rn_addr(LS_Rn),
    .Rd_addr(LS_Rd),
    .SH_amount(LS_SH_AM),
    .offset(LS_offset),
    .Rn(LS_Rn_A),
    .Rd(LS_Rd_B),
    .Rm(LS_Rm_C),
    
    .L_EN(LS_L_EN),
    .WB_EN(LS_WB_EN),
    .WB_Addr(LS_WB_addr),
    .L_Addr(LS_L_addr),
    .WB_data(LS_WB_data),
    .L_data(LS_L_data)
    );
endmodule