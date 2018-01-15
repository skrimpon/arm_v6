`timescale 1ns / 1ps
module MCU(
    input [1:0] A,
	input [2:0] S,
	output result
	);
	assign result = (((A[0]&S[2] | A[1]&(~S[2])) ^ S[1]) & S[0] );	
endmodule
