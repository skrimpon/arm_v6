module branch_prediction(
	input CLK,
	input RST,
	
	input Branch,
	input Branch,
	input [3:0] Branch_PC,
	output Prediction
	);
	
	reg [1:0] Global_History_Reg;
	reg [3:0] Local_History_Table_0;
        reg [3:0] Local_History_Table_1;
        reg [3:0] Local_History_Table_2;
        reg [3:0] Local_History_Table_3;

	always @ (posedge CLK)
		begin
			if(RST)
				Global_History <= 2'b0;
			else
				Global_History_Reg <= (Global_History_Reg << 1) | Branch_Result;
		end

	
	wire Branch_EN = 4'b0;
	history_table table_00(.CLK(CLK), .RST(RST), .Branch_en(Branch_EN[0]), .Branch(Branch), .Branch_PC(Branch_PC), .Prediction(Prediction_00));
        history_table table_01(.CLK(CLK), .RST(RST), .Branch_en(Branch_EN[1]), .Branch(Branch), .Branch_PC(Branch_PC), .Prediction(Prediction_01));
        history_table table_10(.CLK(CLK), .RST(RST), .Branch_en(Branch_EN[2]), .Branch(Branch), .Branch_PC(Branch_PC), .Prediction(Prediction_10));
        history_table table_11(.CLK(CLK), .RST(RST), .Branch_en(Branch_EN[3]), .Branch(Branch), .Branch_PC(Branch_PC), .Prediction(Prediction_11));

endmodule
