module history_table_entry(
	input CLK,
	input RST,
	input Branch_EN,
	input Branch,
	output reg Predict
	);
	reg [1:0] state;
	reg [1:0] next_state;
	
	always @ (posedge CLK)
		begin
			if(RST)
				state <= 2'b00;
			else if(Branch_EN)
				state <= next_state;
		end
	
	always @ ( * )
		begin
			case(state)
			2'b00:
				begin
					if(Branch)
						next_state = 2'b00;
					else
						next_state = 2'b01;
					Predict = 1'b1;
				end
			2'b01:
                                begin
                                        if(Branch)
                                                next_state = 2'b00;
                                        else
                                                next_state = 2'b10;
                                        Predict = 1'b1;
                                end
			2'b10:
                                begin
                                        if(Branch)
                                                next_state = 2'b01;
                                        else
                                                next_state = 2'b11;
                                        Predict = 1'b0;
                                end
			2'b11:
                                begin
                                        if(Branch)
                                                next_state = 2'b10;
                                        else
                                                next_state = 2'b11;
                                        Predict = 1'b0;
                                end
			endcase
		end
	
endmodule
