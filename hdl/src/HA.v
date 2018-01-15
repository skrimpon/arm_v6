`timescale 1ns / 1ps
module HA(
    input A,
    input B,
    output S,
    output Cout
);
assign S = A ^ B;
assign Cout = A&B;

endmodule
