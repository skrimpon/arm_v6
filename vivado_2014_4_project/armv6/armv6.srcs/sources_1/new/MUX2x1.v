`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is a 2x1 Multiplexer                                                      //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module MUX2x1(
	input A,
	input B,
	input sel,
	output res
	);
	assign res = B&sel | A&(~sel);
endmodule 
