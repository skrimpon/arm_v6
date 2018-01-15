module history_table(
	input CLK,
	input RST,
	input Branch_en,
	input Branch,
	input [3:0] Branch_PC,
	output Prediction
	);

	wire [15:0] Predict;
	wire [15:0] Branch_EN;

	assign Branch_EN = 16'b0 | (Branch_en << Branch_PC);

	history_table_entry entry_0000(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[0]), .Branch(Branch), .Predict(Predict[0]));
        history_table_entry entry_0001(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[1]), .Branch(Branch), .Predict(Predict[1]));
        history_table_entry entry_0010(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[2]), .Branch(Branch), .Predict(Predict[2]));
        history_table_entry entry_0011(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[3]), .Branch(Branch), .Predict(Predict[3]));
        history_table_entry entry_0100(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[4]), .Branch(Branch), .Predict(Predict[4]));
        history_table_entry entry_0101(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[5]), .Branch(Branch), .Predict(Predict[5]));
        history_table_entry entry_0110(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[6]), .Branch(Branch), .Predict(Predict[6]));
        history_table_entry entry_0111(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[7]), .Branch(Branch), .Predict(Predict[7]));
        history_table_entry entry_1000(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[8]), .Branch(Branch), .Predict(Predict[8]));
        history_table_entry entry_1001(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[9]), .Branch(Branch), .Predict(Predict[9]));
        history_table_entry entry_1010(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[10]), .Branch(Branch), .Predict(Predict[10]));
        history_table_entry entry_1011(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[11]), .Branch(Branch), .Predict(Predict[11]));
        history_table_entry entry_1100(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[12]), .Branch(Branch), .Predict(Predict[12]));
        history_table_entry entry_1101(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[13]), .Branch(Branch), .Predict(Predict[13]));
        history_table_entry entry_1110(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[14]), .Branch(Branch), .Predict(Predict[14]));
        history_table_entry entry_1111(.CLK(CLK), .RST(RST), .Branch_EN(Branch_EN[15]), .Branch(Branch), .Predict(Predict[15]));
	
	assign Prediction = Predict[Branch_PC];
endmodule
