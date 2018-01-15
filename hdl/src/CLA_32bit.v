`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the module is a combinational 32-bit carry look ahead adder            //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //

module CLA_32bit(
    input Cin,
    input sel,
    input  [31:0] A,
    input  [31:0] B,
    output [31:0]S,
    output Cout
    );
	
	wire [3:0] P;
	wire [3:0] G;
	wire [2:0] CO;
	assign CO[0] = Cin;
	assign Cout = CO[2];
	wire [31:0] B_1 = sel ? (~B + 1) : B;
	
	CLA_16bit FIRST (.A(A[15: 0]), .B(B_1[15: 0]), .Cin(CO[0]), .S(S[15: 0]), .PG(P[0]), .GG(G[0]), .C16(CO[1]));
	CLA_16bit SECOND(.A(A[31:16]), .B(B_1[31:16]), .Cin(CO[1]), .S(S[31:16]), .PG(P[1]), .GG(G[1]), .C16(CO[2]));
	 
endmodule
