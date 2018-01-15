`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the hazzard detection unit of the microprocessor.                      //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module hazzard_detection_unit(
	input CLK,
	input RST,
	input WR,
	input WB_WR,
	input [3:0] RD_Address_A,
	input [3:0] RD_Address_B,
	input [3:0] RD_Address_C,
	input [3:0] WR_Address,
	input [3:0] WB_Address,
	output STALL
    );
    reg STALL_EN;
	reg [15:0] Registers;

	assign EN = (Registers[RD_Address_A] || Registers[RD_Address_B] || Registers[RD_Address_C]);
	assign STALL = ~STALL_EN && EN;

    always @ (posedge CLK) begin
        if(RST)
            STALL_EN <= 1'b0;
        else if(~STALL_EN && EN)
            STALL_EN <= 1'b1;
        else
            STALL_EN <= 1'b0;
    end

	always @ (posedge CLK) begin
        if (RST)
            Registers <= 16'b0;
        else begin
            Registers[WR_Address] = (WR_Address == 0) ? 1'b0 : WR;
            Registers[WB_Address] = (WB_Address == 0) ? 1'b0 : ~WB_WR;
        end
    end
endmodule
