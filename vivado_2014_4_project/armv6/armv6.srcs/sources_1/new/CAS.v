`timescale 1ns / 1ps
module CAS(
	input [3:0] IN,
	output [3:0] OUT
	);
	wire A = IN[0] ^ IN[1];
	assign OUT[0] = ( A & IN[2] ) | ( IN[3] & ( A ^ IN[2] ) );
	assign OUT[1] = A ^ IN[2] ^ IN[3];
	assign OUT[2] = IN[1];
	assign OUT[3] = IN[0];
endmodule
