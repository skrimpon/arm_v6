`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the top testbench module of the microprocessor.                        //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module armv6_TB;
	reg CLK;
	reg RST;

	initial begin
        $dumpfile("armv6.vcd");
        $dumpvars(0,armv6_TB);
        CLK = 0;
        RST = 0;
        #50 RST = 1;
        #50 RST = 0;
        #3000 $finish;
    end

	always CLK = #50 ~CLK;

	armv6 DUT(
		.CLK(CLK),
		.RST(RST)
		);
endmodule
