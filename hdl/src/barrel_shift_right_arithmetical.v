`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2015 01:01:58 PM
// Design Name: 
// Module Name: barrel_shift_right_arithmetical
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module barrel_shift_right_arithmetical(
	input [31:0] unshifted_data,	// unshifted data
	input [4:0] shift,		// how many bits to shift
	output [31:0] shifted_data	// shifted data
	);
	wire [31:0] L0_res;
	wire [31:0] L1_res;
	wire [31:0] L2_res;
	wire [31:0] L3_res;
	// Level 2^0
	MUX2x1 L0_MUX_0(unshifted_data[0], unshifted_data[1], shift[0], L0_res[0]);
	MUX2x1 L0_MUX_1(unshifted_data[1], unshifted_data[2], shift[0], L0_res[1]);
	MUX2x1 L0_MUX_2(unshifted_data[2], unshifted_data[3], shift[0], L0_res[2]);
	MUX2x1 L0_MUX_3(unshifted_data[3], unshifted_data[4], shift[0], L0_res[3]);
	MUX2x1 L0_MUX_4(unshifted_data[4], unshifted_data[5], shift[0], L0_res[4]);
	MUX2x1 L0_MUX_5(unshifted_data[5], unshifted_data[6], shift[0], L0_res[5]);
	MUX2x1 L0_MUX_6(unshifted_data[6], unshifted_data[7], shift[0], L0_res[6]);
	MUX2x1 L0_MUX_7(unshifted_data[7], unshifted_data[8], shift[0], L0_res[7]);
	MUX2x1 L0_MUX_8(unshifted_data[8], unshifted_data[9], shift[0], L0_res[8]);
	MUX2x1 L0_MUX_9(unshifted_data[9], unshifted_data[10], shift[0], L0_res[9]);
	MUX2x1 L0_MUX_10(unshifted_data[10], unshifted_data[11], shift[0], L0_res[10]);
	MUX2x1 L0_MUX_11(unshifted_data[11], unshifted_data[12], shift[0], L0_res[11]);
	MUX2x1 L0_MUX_12(unshifted_data[12], unshifted_data[13], shift[0], L0_res[12]);
	MUX2x1 L0_MUX_13(unshifted_data[13], unshifted_data[14], shift[0], L0_res[13]);
	MUX2x1 L0_MUX_14(unshifted_data[14], unshifted_data[15], shift[0], L0_res[14]);
	MUX2x1 L0_MUX_15(unshifted_data[15], unshifted_data[16], shift[0], L0_res[15]);
	MUX2x1 L0_MUX_16(unshifted_data[16], unshifted_data[17], shift[0], L0_res[16]);
	MUX2x1 L0_MUX_17(unshifted_data[17], unshifted_data[18], shift[0], L0_res[17]);
	MUX2x1 L0_MUX_18(unshifted_data[18], unshifted_data[19], shift[0], L0_res[18]);
	MUX2x1 L0_MUX_19(unshifted_data[19], unshifted_data[20], shift[0], L0_res[19]);
	MUX2x1 L0_MUX_20(unshifted_data[20], unshifted_data[21], shift[0], L0_res[20]);
	MUX2x1 L0_MUX_21(unshifted_data[21], unshifted_data[22], shift[0], L0_res[21]);
	MUX2x1 L0_MUX_22(unshifted_data[22], unshifted_data[23], shift[0], L0_res[22]);
	MUX2x1 L0_MUX_23(unshifted_data[23], unshifted_data[24], shift[0], L0_res[23]);
	MUX2x1 L0_MUX_24(unshifted_data[24], unshifted_data[25], shift[0], L0_res[24]);
	MUX2x1 L0_MUX_25(unshifted_data[25], unshifted_data[26], shift[0], L0_res[25]);
	MUX2x1 L0_MUX_26(unshifted_data[26], unshifted_data[27], shift[0], L0_res[26]);
	MUX2x1 L0_MUX_27(unshifted_data[27], unshifted_data[28], shift[0], L0_res[27]);
	MUX2x1 L0_MUX_28(unshifted_data[28], unshifted_data[29], shift[0], L0_res[28]);
	MUX2x1 L0_MUX_29(unshifted_data[29], unshifted_data[30], shift[0], L0_res[29]);
	MUX2x1 L0_MUX_30(unshifted_data[30], unshifted_data[31], shift[0], L0_res[30]);
	MUX2x1 L0_MUX_31(unshifted_data[31], unshifted_data[31], shift[0], L0_res[31]);
	// Level 2^1
	MUX2x1 L1_MUX_0(L0_res[0], L0_res[2], shift[1], L1_res[0]);
	MUX2x1 L1_MUX_1(L0_res[1], L0_res[3], shift[1], L1_res[1]);
	MUX2x1 L1_MUX_2(L0_res[2], L0_res[4], shift[1], L1_res[2]);
	MUX2x1 L1_MUX_3(L0_res[3], L0_res[5], shift[1], L1_res[3]);
	MUX2x1 L1_MUX_4(L0_res[4], L0_res[6], shift[1], L1_res[4]);
	MUX2x1 L1_MUX_5(L0_res[5], L0_res[7], shift[1], L1_res[5]);
	MUX2x1 L1_MUX_6(L0_res[6], L0_res[8], shift[1], L1_res[6]);
	MUX2x1 L1_MUX_7(L0_res[7], L0_res[9], shift[1], L1_res[7]);
	MUX2x1 L1_MUX_8(L0_res[8], L0_res[10], shift[1], L1_res[8]);
	MUX2x1 L1_MUX_9(L0_res[9], L0_res[11], shift[1], L1_res[9]);
	MUX2x1 L1_MUX_10(L0_res[10], L0_res[12], shift[1], L1_res[10]);
	MUX2x1 L1_MUX_11(L0_res[11], L0_res[13], shift[1], L1_res[11]);
	MUX2x1 L1_MUX_12(L0_res[12], L0_res[14], shift[1], L1_res[12]);
	MUX2x1 L1_MUX_13(L0_res[13], L0_res[15], shift[1], L1_res[13]);
	MUX2x1 L1_MUX_14(L0_res[14], L0_res[16], shift[1], L1_res[14]);
	MUX2x1 L1_MUX_15(L0_res[15], L0_res[17], shift[1], L1_res[15]);
	MUX2x1 L1_MUX_16(L0_res[16], L0_res[18], shift[1], L1_res[16]);
	MUX2x1 L1_MUX_17(L0_res[17], L0_res[19], shift[1], L1_res[17]);
	MUX2x1 L1_MUX_18(L0_res[18], L0_res[20], shift[1], L1_res[18]);
	MUX2x1 L1_MUX_19(L0_res[19], L0_res[21], shift[1], L1_res[19]);
	MUX2x1 L1_MUX_20(L0_res[20], L0_res[22], shift[1], L1_res[20]);
	MUX2x1 L1_MUX_21(L0_res[21], L0_res[23], shift[1], L1_res[21]);
	MUX2x1 L1_MUX_22(L0_res[22], L0_res[24], shift[1], L1_res[22]);
	MUX2x1 L1_MUX_23(L0_res[23], L0_res[25], shift[1], L1_res[23]);
	MUX2x1 L1_MUX_24(L0_res[24], L0_res[26], shift[1], L1_res[24]);
	MUX2x1 L1_MUX_25(L0_res[25], L0_res[27], shift[1], L1_res[25]);
	MUX2x1 L1_MUX_26(L0_res[26], L0_res[28], shift[1], L1_res[26]);
	MUX2x1 L1_MUX_27(L0_res[27], L0_res[29], shift[1], L1_res[27]);
	MUX2x1 L1_MUX_28(L0_res[28], L0_res[30], shift[1], L1_res[28]);
	MUX2x1 L1_MUX_29(L0_res[29], L0_res[31], shift[1], L1_res[29]);
	MUX2x1 L1_MUX_30(L0_res[30], L0_res[31], shift[1], L1_res[30]);
	MUX2x1 L1_MUX_31(L0_res[31], L0_res[31], shift[1], L1_res[31]);
	// Level 2^2
	MUX2x1 L2_MUX_0(L1_res[0], L1_res[4], shift[2], L2_res[0]);
	MUX2x1 L2_MUX_1(L1_res[1], L1_res[5], shift[2], L2_res[1]);
	MUX2x1 L2_MUX_2(L1_res[2], L1_res[6], shift[2], L2_res[2]);
	MUX2x1 L2_MUX_3(L1_res[3], L1_res[7], shift[2], L2_res[3]);
	MUX2x1 L2_MUX_4(L1_res[4], L1_res[8], shift[2], L2_res[4]);
	MUX2x1 L2_MUX_5(L1_res[5], L1_res[9], shift[2], L2_res[5]);
	MUX2x1 L2_MUX_6(L1_res[6], L1_res[10], shift[2], L2_res[6]);
	MUX2x1 L2_MUX_7(L1_res[7], L1_res[11], shift[2], L2_res[7]);
	MUX2x1 L2_MUX_8(L1_res[8], L1_res[12], shift[2], L2_res[8]);
	MUX2x1 L2_MUX_9(L1_res[9], L1_res[13], shift[2], L2_res[9]);
	MUX2x1 L2_MUX_10(L1_res[10], L1_res[14], shift[2], L2_res[10]);
	MUX2x1 L2_MUX_11(L1_res[11], L1_res[15], shift[2], L2_res[11]);
	MUX2x1 L2_MUX_12(L1_res[12], L1_res[16], shift[2], L2_res[12]);
	MUX2x1 L2_MUX_13(L1_res[13], L1_res[17], shift[2], L2_res[13]);
	MUX2x1 L2_MUX_14(L1_res[14], L1_res[18], shift[2], L2_res[14]);
	MUX2x1 L2_MUX_15(L1_res[15], L1_res[19], shift[2], L2_res[15]);
	MUX2x1 L2_MUX_16(L1_res[16], L1_res[20], shift[2], L2_res[16]);
	MUX2x1 L2_MUX_17(L1_res[17], L1_res[21], shift[2], L2_res[17]);
	MUX2x1 L2_MUX_18(L1_res[18], L1_res[22], shift[2], L2_res[18]);
	MUX2x1 L2_MUX_19(L1_res[19], L1_res[23], shift[2], L2_res[19]);
	MUX2x1 L2_MUX_20(L1_res[20], L1_res[24], shift[2], L2_res[20]);
	MUX2x1 L2_MUX_21(L1_res[21], L1_res[25], shift[2], L2_res[21]);
	MUX2x1 L2_MUX_22(L1_res[22], L1_res[26], shift[2], L2_res[22]);
	MUX2x1 L2_MUX_23(L1_res[23], L1_res[27], shift[2], L2_res[23]);
	MUX2x1 L2_MUX_24(L1_res[24], L1_res[28], shift[2], L2_res[24]);
	MUX2x1 L2_MUX_25(L1_res[25], L1_res[29], shift[2], L2_res[25]);
	MUX2x1 L2_MUX_26(L1_res[26], L1_res[30], shift[2], L2_res[26]);
	MUX2x1 L2_MUX_27(L1_res[27], L1_res[31], shift[2], L2_res[27]);
	MUX2x1 L2_MUX_28(L1_res[28], L1_res[31], shift[2], L2_res[28]);
	MUX2x1 L2_MUX_29(L1_res[29], L1_res[31], shift[2], L2_res[29]);
	MUX2x1 L2_MUX_30(L1_res[30], L1_res[31], shift[2], L2_res[30]);
	MUX2x1 L2_MUX_31(L1_res[31], L1_res[31], shift[2], L2_res[31]);
	// Level 2^3
	MUX2x1 L3_MUX_0(L2_res[0], L2_res[8], shift[3], L3_res[0]);
	MUX2x1 L3_MUX_1(L2_res[1], L2_res[9], shift[3], L3_res[1]);
	MUX2x1 L3_MUX_2(L2_res[2], L2_res[10], shift[3], L3_res[2]);
	MUX2x1 L3_MUX_3(L2_res[3], L2_res[11], shift[3], L3_res[3]);
	MUX2x1 L3_MUX_4(L2_res[4], L2_res[12], shift[3], L3_res[4]);
	MUX2x1 L3_MUX_5(L2_res[5], L2_res[13], shift[3], L3_res[5]);
	MUX2x1 L3_MUX_6(L2_res[6], L2_res[14], shift[3], L3_res[6]);
	MUX2x1 L3_MUX_7(L2_res[7], L2_res[15], shift[3], L3_res[7]);
	MUX2x1 L3_MUX_8(L2_res[8], L2_res[16], shift[3], L3_res[8]);
	MUX2x1 L3_MUX_9(L2_res[9], L2_res[17], shift[3], L3_res[9]);
	MUX2x1 L3_MUX_10(L2_res[10], L2_res[18], shift[3], L3_res[10]);
	MUX2x1 L3_MUX_11(L2_res[11], L2_res[19], shift[3], L3_res[11]);
	MUX2x1 L3_MUX_12(L2_res[12], L2_res[20], shift[3], L3_res[12]);
	MUX2x1 L3_MUX_13(L2_res[13], L2_res[21], shift[3], L3_res[13]);
	MUX2x1 L3_MUX_14(L2_res[14], L2_res[22], shift[3], L3_res[14]);
	MUX2x1 L3_MUX_15(L2_res[15], L2_res[23], shift[3], L3_res[15]);
	MUX2x1 L3_MUX_16(L2_res[16], L2_res[24], shift[3], L3_res[16]);
	MUX2x1 L3_MUX_17(L2_res[17], L2_res[25], shift[3], L3_res[17]);
	MUX2x1 L3_MUX_18(L2_res[18], L2_res[26], shift[3], L3_res[18]);
	MUX2x1 L3_MUX_19(L2_res[19], L2_res[27], shift[3], L3_res[19]);
	MUX2x1 L3_MUX_20(L2_res[20], L2_res[28], shift[3], L3_res[20]);
	MUX2x1 L3_MUX_21(L2_res[21], L2_res[29], shift[3], L3_res[21]);
	MUX2x1 L3_MUX_22(L2_res[22], L2_res[30], shift[3], L3_res[22]);
	MUX2x1 L3_MUX_23(L2_res[23], L2_res[31], shift[3], L3_res[23]);
	MUX2x1 L3_MUX_24(L2_res[24], L2_res[31], shift[3], L3_res[24]);
	MUX2x1 L3_MUX_25(L2_res[25], L2_res[31], shift[3], L3_res[25]);
	MUX2x1 L3_MUX_26(L2_res[26], L2_res[31], shift[3], L3_res[26]);
	MUX2x1 L3_MUX_27(L2_res[27], L2_res[31], shift[3], L3_res[27]);
	MUX2x1 L3_MUX_28(L2_res[28], L2_res[31], shift[3], L3_res[28]);
	MUX2x1 L3_MUX_29(L2_res[29], L2_res[31], shift[3], L3_res[29]);
	MUX2x1 L3_MUX_30(L2_res[30], L2_res[31], shift[3], L3_res[30]);
	MUX2x1 L3_MUX_31(L2_res[31], L2_res[31], shift[3], L3_res[31]);
	// Level 2^4
	MUX2x1 L4_MUX_0(L3_res[0], L3_res[16], shift[4], shifted_data[0]);
	MUX2x1 L4_MUX_1(L3_res[1], L3_res[17], shift[4], shifted_data[1]);
	MUX2x1 L4_MUX_2(L3_res[2], L3_res[18], shift[4], shifted_data[2]);
	MUX2x1 L4_MUX_3(L3_res[3], L3_res[19], shift[4], shifted_data[3]);
	MUX2x1 L4_MUX_4(L3_res[4], L3_res[20], shift[4], shifted_data[4]);
	MUX2x1 L4_MUX_5(L3_res[5], L3_res[21], shift[4], shifted_data[5]);
	MUX2x1 L4_MUX_6(L3_res[6], L3_res[22], shift[4], shifted_data[6]);
	MUX2x1 L4_MUX_7(L3_res[7], L3_res[23], shift[4], shifted_data[7]);
	MUX2x1 L4_MUX_8(L3_res[8], L3_res[24], shift[4], shifted_data[8]);
	MUX2x1 L4_MUX_9(L3_res[9], L3_res[25], shift[4], shifted_data[9]);
	MUX2x1 L4_MUX_10(L3_res[10], L3_res[26], shift[4], shifted_data[10]);
	MUX2x1 L4_MUX_11(L3_res[11], L3_res[27], shift[4], shifted_data[11]);
	MUX2x1 L4_MUX_12(L3_res[12], L3_res[28], shift[4], shifted_data[12]);
	MUX2x1 L4_MUX_13(L3_res[13], L3_res[29], shift[4], shifted_data[13]);
	MUX2x1 L4_MUX_14(L3_res[14], L3_res[30], shift[4], shifted_data[14]);
	MUX2x1 L4_MUX_15(L3_res[15], L3_res[31], shift[4], shifted_data[15]);
	MUX2x1 L4_MUX_16(L3_res[16], L3_res[31], shift[4], shifted_data[16]);
	MUX2x1 L4_MUX_17(L3_res[17], L3_res[31], shift[4], shifted_data[17]);
	MUX2x1 L4_MUX_18(L3_res[18], L3_res[31], shift[4], shifted_data[18]);
	MUX2x1 L4_MUX_19(L3_res[19], L3_res[31], shift[4], shifted_data[19]);
	MUX2x1 L4_MUX_20(L3_res[20], L3_res[31], shift[4], shifted_data[20]);
	MUX2x1 L4_MUX_21(L3_res[21], L3_res[31], shift[4], shifted_data[21]);
	MUX2x1 L4_MUX_22(L3_res[22], L3_res[31], shift[4], shifted_data[22]);
	MUX2x1 L4_MUX_23(L3_res[23], L3_res[31], shift[4], shifted_data[23]);
	MUX2x1 L4_MUX_24(L3_res[24], L3_res[31], shift[4], shifted_data[24]);
	MUX2x1 L4_MUX_25(L3_res[25], L3_res[31], shift[4], shifted_data[25]);
	MUX2x1 L4_MUX_26(L3_res[26], L3_res[31], shift[4], shifted_data[26]);
	MUX2x1 L4_MUX_27(L3_res[27], L3_res[31], shift[4], shifted_data[27]);
	MUX2x1 L4_MUX_28(L3_res[28], L3_res[31], shift[4], shifted_data[28]);
	MUX2x1 L4_MUX_29(L3_res[29], L3_res[31], shift[4], shifted_data[29]);
	MUX2x1 L4_MUX_30(L3_res[30], L3_res[31], shift[4], shifted_data[30]);
	MUX2x1 L4_MUX_31(L3_res[31], L3_res[31], shift[4], shifted_data[31]);
endmodule