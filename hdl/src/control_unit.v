`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the module is the control unit of the microprocessor.                  //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module control_unit(
    input A,
    input I,
    input K,
    input L,
    input IR4,
    input [3:0] CONDITION,
    input [3:0] CTRL_REG,
    input [5:0] OPCODE,
    output reg WB,
    output reg EXEC,
    output reg RD_CTRL_C,
    output reg [1:0] RD_CTRL_B,
    output reg [1:0] RD_CTRL_A,
    output reg [1:0] WR_CTRL,
    output reg [2:0] ISS
);
	
    always @ ( * ) begin
        casez(OPCODE)
        // MUL Datapath
            6'b001001: begin
                ISS = 3'b001;
                WB = 1'b1;
                WR_CTRL = 2'b01;
                RD_CTRL_A = A ? 2'b10 : 2'b00;
                RD_CTRL_B = 2'b10;
                RD_CTRL_C = 1'b1;
            end
        // ALU Datapath
            6'b00????: begin
                ISS = 3'b000;
                WB = 1'b1;
                WR_CTRL = 2'b10;
                RD_CTRL_A = 2'b01;
                RD_CTRL_B = I ? 2'b00 : (IR4 ? 2'b10 : 2'b00);
                RD_CTRL_C = I ? 1'b0 : 1'b1;
            end
        // DIV Datapath
            6'b111001: begin
                ISS = 3'b010;
                WB = 1'b1;
                WR_CTRL = 2'b01;
                RD_CTRL_A = A ? 2'b10 : 2'b00;
                RD_CTRL_B = 2'b10;
                RD_CTRL_C = 1'b1;
            end
        // LS Datapath
            6'b01????: begin
                ISS = 3'b011;
                WB = L ? 1'b0 : 1'b1;
                WR_CTRL = 2'b10;
                RD_CTRL_A = 2'b01;
                RD_CTRL_B = L ? 2'b00 : 2'b01;
                RD_CTRL_C = I ? 1'b1 : 1'b0;
            end
        // BJ Datapath
            6'b10????: begin
                ISS = 3'b100;
                WB = K ? 1'b1 : 1'b0;
                WR_CTRL = 2'b00;
                RD_CTRL_A = 2'b00;
                RD_CTRL_B = 2'b00;
                RD_CTRL_C = 1'b0;
            end
            default: begin
                ISS = 3'b00;
                WB = 1'b0;
                WR_CTRL = 2'b00;
                RD_CTRL_A = 2'b00;
                RD_CTRL_B = 2'b00;
                RD_CTRL_C = 1'b0;
            end
        endcase
    end
    
    wire C = CTRL_REG[0];
    wire V = CTRL_REG[1];
    wire Z = CTRL_REG[2];
    wire N = CTRL_REG[3];

    always @ ( * ) begin
        case(CONDITION)
            4'h0: EXEC = (Z == 1);
            4'h1: EXEC = (Z == 0);
            4'h2: EXEC = (C == 1);
            4'h3: EXEC = (C == 0);
            4'h4: EXEC = (N == 1);
            4'h5: EXEC = (N == 0);
            4'h6: EXEC = (V == 1);
            4'h7: EXEC = (V == 0);
            4'h8: EXEC = ((~C | Z) == 0);
            4'h9: EXEC = ((~C | Z) == 1);
            4'ha: EXEC = ((N ^ V) == 0);
            4'hb: EXEC = ((N ^ V) == 1);
            4'hc: EXEC = ((Z | (N ^ V)) == 0);
            4'hd: EXEC = ((Z | (N ^ V)) == 1);
            4'he: EXEC = 1'b1;
            4'hf: EXEC = 1'b0;
        endcase
    end
endmodule
