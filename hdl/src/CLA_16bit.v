`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the module is a combinational 16-bit carry look ahead adder            //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module CLA_16bit(
    input  Cin,
    input  [15:0] A,
    input  [15:0] B,
    output [15:0]S,
    output PG,
    output GG,
    output C16
    );

	wire [3:0] P;
	wire [3:0] G;
	wire [4:0] Cout;
	assign Cout[0] = Cin;
	assign C16 = Cout[4];
	assign PG = P[0] & P[1] & P[2] & P[3];
	assign GG = G[3] | ( G[2] & P[3] ) | ( G[1] & P[2] & P[3] ) | ( G[0] & P[1] & P[2] & P[3] );

	CLA_4bit FIRST (.A(A[ 3: 0]), .B(B[ 3: 0]), .Cin(Cout[0]), .S(S[ 3: 0]), .PG(P[0]), .GG(G[0]), .Cout(Cout[1]));
	CLA_4bit SECOND(.A(A[ 7: 4]), .B(B[ 7: 4]),	.Cin(Cout[1]), .S(S[ 7: 4]), .PG(P[1]), .GG(G[1]), .Cout(Cout[2]));
	CLA_4bit THIRD (.A(A[11: 8]), .B(B[11: 8]), .Cin(Cout[2]), .S(S[11: 8]), .PG(P[2]), .GG(G[2]), .Cout(Cout[3]));
	CLA_4bit FOURTH(.A(A[15:12]), .B(B[15:12]), .Cin(Cout[3]), .S(S[15:12]), .PG(P[3]), .GG(G[3]), .Cout(Cout[4]));	 	 
endmodule
