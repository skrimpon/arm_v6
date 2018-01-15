`timescale 1ns / 1ps
module FA(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
assign S = A ^ B ^ Cin;
assign Cout = A&Cin | B&Cin | A&B; 

endmodule

