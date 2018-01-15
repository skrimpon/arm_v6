`timescale 1ns / 1ps
module register_file(
	input  CLK,			           // CLOCK
	input  RST,			           // SYSTEM RESET
	input  WRITE,			       // Write Enable Signal
	input  processor_mode,		   // Determines Processor's mode ( User or Supervisor )
	input  [3:0]  read_address_1,  // First Read Port
	input  [3:0]  read_address_2,  // Second Read Port
	input  [3:0]  read_address_3,  // Third Read Port
	input  [3:0]  write_address,   // Write port
	input  [31:0] write_data,	   // Write data
	output reg [31:0] read_data_1, // Data from read_1
	output reg [31:0] read_data_2, // Data from read_2
	output reg [31:0] read_data_3  // Data from read_3
	);
	localparam S0 = 4'h0,
	           S1 = 4'h1,
	           S2 = 4'h2,
	           S3 = 4'h3,
	           S4 = 4'h4,
	           S5 = 4'h5,
	           S6 = 4'h6,
	           S7 = 4'h7,
	           S8 = 4'h8,
	           S9 = 4'h9,
	           S10= 4'ha,
	           S11= 4'hb,
	           S12= 4'hc,
	           S13= 4'hd,
	           S14= 4'he,
	           S15= 4'hf;
// ====================================================================================
// 				Parameters, Register, and Wires
// ====================================================================================
	reg [31:0] unbanked_registers_0;	// The physical register refered to each of them is the same
	reg [31:0] unbanked_registers_1;	// in all processor modes.
	reg [31:0] unbanked_registers_2;
	reg [31:0] unbanked_registers_3;
	reg [31:0] unbanked_registers_4;
	reg [31:0] unbanked_registers_5;
	reg [31:0] unbanked_registers_6;
	reg [31:0] unbanked_registers_7;

	reg [31:0] banked_registers_0;		// The physical register refered to each of them depends
	reg [31:0] banked_registers_1;		// on the current processor mode. But we support only User and Supervisor
	reg [31:0] banked_registers_2;		// mode so this registers are the same for both modes.
	reg [31:0] banked_registers_3;
	reg [31:0] banked_registers_4;

	reg [31:0] R13;				// Register 13 for the User mode
	reg [31:0] R14;				// Register 14 for the User mode
	reg [31:0] R13_svc;			// Register 13 for the Supervisor mode
	reg [31:0] R14_svc;			// Register 14 for the Supervisor mode
	reg [31:0] PC;				// The program counter
//  ===================================================================================
// 					Implementation
//  ===================================================================================
	//-----------------------------------------------------------
	//	READ FIRST ADDRESS IN THE SECOND HALF OF THE PULSE
	//-----------------------------------------------------------
    always @ ( * ) begin
        if( RST )
            read_data_1 = 32'b0;
        else begin
            case(read_address_1)
                S0  : read_data_1 = unbanked_registers_0;
                S1  : read_data_1 = unbanked_registers_1;
                S2  : read_data_1 = unbanked_registers_2;
                S3  : read_data_1 = unbanked_registers_3;
                S4  : read_data_1 = unbanked_registers_4;
                S5  : read_data_1 = unbanked_registers_5;
                S6  : read_data_1 = unbanked_registers_6;
                S7  : read_data_1 = unbanked_registers_7;
                S8  : read_data_1 = banked_registers_0;
                S9  : read_data_1 = banked_registers_1;
                S10 : read_data_1 = banked_registers_2;
                S11 : read_data_1 = banked_registers_3;
                S12 : read_data_1 = banked_registers_4;
                S13 : read_data_1 = (processor_mode) ? R13 : R13_svc;
                S14 : read_data_1 = (processor_mode) ? R14 : R14_svc;
                S15 : read_data_1 = PC;
                default : read_data_1 = 32'b0;
            endcase
        end
    end
	//-----------------------------------------------------------
	//	READ SECOND ADDRESS IN THE SECOND HALF OF THE PULSE
	//-----------------------------------------------------------
	always @ ( * ) begin
        if( RST )
            read_data_2 = 32'b0;
        else begin
            case(read_address_2)
                S0  : read_data_2 = unbanked_registers_0;
                S1  : read_data_2 = unbanked_registers_1;
                S2  : read_data_2 = unbanked_registers_2;
                S3  : read_data_2 = unbanked_registers_3;
                S4  : read_data_2 = unbanked_registers_4;
                S5  : read_data_2 = unbanked_registers_5;
                S6  : read_data_2 = unbanked_registers_6;
                S7  : read_data_2 = unbanked_registers_7;
                S8  : read_data_2 = banked_registers_0;
                S9  : read_data_2 = banked_registers_1;
                S10 : read_data_2 = banked_registers_2;
                S11 : read_data_2 = banked_registers_3;
                S12 : read_data_2 = banked_registers_4;
                S13 : read_data_2 = processor_mode ? R13 : R13_svc;
                S14 : read_data_2 = processor_mode ? R14 : R14_svc;
                S15 : read_data_2 = PC;
                default : read_data_2 = 32'b0;
            endcase
        end
    end
	//-------------------------------------------------------------
	//	READ THIRD ADDRESS IN THE SECOND HALF OF THE PULSE
	//-------------------------------------------------------------
	always @ ( * ) begin
        if( RST )
            read_data_3 = 32'b0;
        else begin
            case(read_address_3)
                S0  : read_data_3 = unbanked_registers_0;
                S1  : read_data_3 = unbanked_registers_1;
                S2  : read_data_3 = unbanked_registers_2;
                S3  : read_data_3 = unbanked_registers_3;
                S4  : read_data_3 = unbanked_registers_4;
                S5  : read_data_3 = unbanked_registers_5;
                S6  : read_data_3 = unbanked_registers_6;
                S7  : read_data_3 = unbanked_registers_7;
                S8  : read_data_3 = banked_registers_0;
                S9  : read_data_3 = banked_registers_1;
                S10 : read_data_3 = banked_registers_2;
                S11 : read_data_3 = banked_registers_3;
                S12 : read_data_3 = banked_registers_4;
                S13 : read_data_3 = processor_mode ? R13 : R13_svc;
                S14 : read_data_3 = processor_mode ? R14 : R14_svc;
                S15 : read_data_3 = PC;
                default : read_data_3 = 32'b0;
            endcase
        end
    end
	//-----------------------------------------------------------
	//	WRITE DATA IN THE FIRST HALF OF THE PULSE
	//-----------------------------------------------------------
	always @ ( * ) begin
        if( RST ) begin
            unbanked_registers_0 <= 32'b0;
            unbanked_registers_1 <= 32'b0;
            unbanked_registers_2 <= 32'b0;
            unbanked_registers_3 <= 32'b0;
            unbanked_registers_4 <= 32'b0;
            unbanked_registers_5 <= 32'b0;
            unbanked_registers_6 <= 32'b0;
            unbanked_registers_7 <= 32'b0;
            banked_registers_0 <= 32'b0;
            banked_registers_1 <= 32'b0;
            banked_registers_2 <= 32'b0;
            banked_registers_3 <= 32'b0;
            banked_registers_4 <= 32'b0;
            R13 <= 32'b0;
            R14 <= 32'b0;
            R13_svc <= 32'b0;
            R14_svc <= 32'b0;
            PC <= 32'b0;
        end
        else if ( WRITE ) begin
            case(write_address)
                S0  : unbanked_registers_0 <= write_data;
                S1  : unbanked_registers_1 <= write_data;
                S2  : unbanked_registers_2 <= write_data;
                S3  : unbanked_registers_3 <= write_data;
                S4  : unbanked_registers_4 <= write_data;
                S5  : unbanked_registers_5 <= write_data;
                S6  : unbanked_registers_6 <= write_data;
                S7  : unbanked_registers_7 <= write_data;
                S8  : banked_registers_0   <= write_data;
                S9  : banked_registers_1   <= write_data;
                S10 : banked_registers_2   <= write_data;
                S11 : banked_registers_3   <= write_data;
                S12 : banked_registers_4   <= write_data;
                S13 : begin
                    R13     <= processor_mode ? write_data : R13;
                    R13_svc <= processor_mode ? write_data : R13_svc;
                end
                S14 : begin
                    R14     <= processor_mode ? write_data : R14;
                    R14_svc <= processor_mode ? write_data : R14_svc;
                end
                S15 : PC <= (write_data & 32'hfffffffe);
                default : read_data_3 <= 32'b0;
            endcase
        end				
    end
endmodule
