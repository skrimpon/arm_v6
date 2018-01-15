`timescale 1ns / 1ps
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
// Author            : Panagiotis Skrimponis                                                          //
// Organization      : University of Thessaly                                                         //
// Department        : Electrical and Computer Engineering                                            //
// Course            : CE432 Computer Architecture                                                    //
// Supervisor        : Dimitriou Georgios                                                             //
// Project Title     : Design and Implementation of a microprocessor based on ARMv6 microarchitecture //
//                                                                                                    //
// Module Description: This is the module is a combinational 64-bit carry look ahead adder            //
//                                                                                                    //
// ////////////////////////////////////////////////////////////////////////////////////////////////// //
module CLA_64bit(
    input [63:0] A,
    input [63:0] B,
    input Cin,
    output [63:0]S,
    output PG,
    output GG,
    output C32
    );
	wire [3:0] P;
	wire [3:0] G;
	wire [4:0] Cout;
	assign Cout[0] = Cin;
	assign C32 = Cout[4];
	assign PG = P[0] & P[1] & P[2] & P[3];
	assign GG = G[3] | ( G[2] & P[3] ) | ( G[1] & P[2] & P[3] ) | ( G[0] & P[1] & P[2] & P[3] );
	
	CLA_16bit FIRST(
    .A(A[15:0]), 
    .B(B[15:0]), 
    .Cin(Cout[0]), 
    .S(S[15:0]), 
    .PG(P[0]),
	 .GG(G[0]),
	 .C16(Cout[1])
    );
	CLA_16bit SECOND(
    .A(A[31:16]), 
    .B(B[31:16]), 
    .Cin(Cout[1]), 
    .S(S[31:16]), 
    .PG(P[1]),
	 .GG(G[1]),
	 .C16(Cout[2])
    );
	CLA_16bit THIRD(
    .A(A[47:32]), 
    .B(B[47:32]), 
    .Cin(Cout[2]), 
    .S(S[47:32]), 
    .PG(P[2]),
	 .GG(G[2]),
	 .C16(Cout[3])
    );
	CLA_16bit FOURTH(
    .A(A[63:48]), 
    .B(B[63:48]), 
    .Cin(Cout[3]), 
    .S(S[63:48]), 
    .PG(P[3]),
	 .GG(G[3]),
	 .C16(Cout[4])
    );
	 
endmodule