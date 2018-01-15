////////////////////////////////////////////////////////////////////////////////
//
// Organization: University of Thessaly
// Course: CE432 - Computer Architecture
// Author: Panagiotis Skrimponis
// AEM: 1256
//
// Description: 
//				
// Revision: Version 1.0
//
////////////////////////////////////////////////////////////////////////////////
#include <map>
#include <string>
#include <iostream>
#include <fstream>
#include <bitset>
#include <cstdlib>

#define INPUT "program.in"
#define OUTPUT "program.out"
#define OPCODE_MAX 20
#define CONDITION_MAX 15
#define SHIFT_MAX 4
#define REGISTER_MAX 16

int main(void)
{
	// Opcode
	std::string opcode_keys[] = {	  "ADD",      "ADC",      "SUB",      "SBC",      "RSB",      "RSC",      "AND",  
	 							 	  "ORR",      "EOR",      "BIC",      "CMP",      "CMN",      "TST",      "TEQ",
	 							 	  "MOV",      "MVN",      "MUL",      "MLA",      "DIV",      "DVA"};
	std::string opcode_vals[] = {"00001000", "00001010", "00000100", "00001100", "00000110", "00001110", "00000000", 
	 						 	 "00011000", "00000010", "00011100", "00010100", "00010110", "00010000", "00010010", 
	 						 	 "00011010", "00011110", "00000000", "00000010", "11000000", "11000010"};
	// Condition
	std::string condition_keys[] = {  "EQ",	  "NE",	  "CS",   "CC",   "MI",   "PL",   "VS",   "VC",   "HI",
								      "LS",	  "GE",	  "LT",	  "GT",	  "LE",	  "AL"};
	std::string condition_vals[] = {"0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000",
								    "1001", "1010", "1011", "1100", "1101", "1110"};
	// Shift
	std::string shift_keys[] = {"LSL", "LSR", "ASR", "ROR"};
	std::string shift_vals[] = { "00",  "01",  "10",  "11"};
	// Registers,
	std::string register_keys[] = {  "R0",   "R1",   "R2",   "R3",   "R4",   "R5",   "R6",   "R7",   "R8",
									 "R9",  "R10",  "R11",  "R12",  "R13",  "R14",  "R15"};
	std::string register_vals[] = {"0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000",
								   "1001", "1010", "1011", "1100", "1101", "1110", "1111"};
	std::map< std::string, std::string > opcode_hash;
	std::map< std::string, std::string > condition_hash;
	std::map< std::string, std::string > shift_hash;
	std::map< std::string, std::string > register_hash;

	for(int i=0; i<OPCODE_MAX; i++) opcode_hash[opcode_keys[i]] = opcode_vals[i];
	for(int i=0; i<CONDITION_MAX; i++) condition_hash[condition_keys[i]] = condition_vals[i];
	for(int i=0; i<SHIFT_MAX; i++) shift_hash[shift_keys[i]] = shift_vals[i];
	for(int i=0; i<REGISTER_MAX; i++) register_hash[register_keys[i]] = register_vals[i];

	std::string line;
	std::string instruction;
	std::ifstream fi(INPUT);
	std::ofstream fo(OUTPUT);
	instruction.assign("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
	int register_idx, iss_idx, ror_idx, instruction_idx, register_int;
	instruction_idx = 0;
	if (fi.is_open())
	{
		while ( fi >> line )
		{

			if(opcode_hash[line] != "")
			{
				if(instruction_idx > 0)
				{
					std::cout << instruction << '\n';
					fo << "@" << (instruction_idx-1)<< " " << instruction << '\n';
				}
				instruction_idx++;
				instruction.assign("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
				iss_idx = ror_idx = 0;
				register_idx = 0;
				instruction.replace(4, 8, opcode_hash[line]);
				if((line=="MUL")||(line=="MLA")) iss_idx=1;
				else if((line=="DIV")||(line=="DVA")) iss_idx=2;
			}
			else if(condition_hash[line] != "")
			{
				instruction.replace(0, 4, condition_hash[line]);
			}
			else if(shift_hash[line] != "")
			{
				if((line == "ROR") && (register_idx == 2)) ror_idx++;
				else instruction.replace(25, 2, shift_hash[line]);
			}
			else if(register_hash[line] != "")
			{
				line.erase(0,1);
				register_int = atoi(line.c_str());
				std::bitset< 4 >bitset_register(register_int);
				line = bitset_register.to_string< char,std::string::traits_type,std::string::allocator_type >();
				if(register_idx == 0)
				{
					if(iss_idx == 0) instruction.replace(16, 4, line);
					else instruction.replace(12, 4, line);	
					register_idx++;			
				}
				else if(register_idx == 1)
				{
					if(iss_idx == 0) instruction.replace(12, 4, line);
					else instruction.replace(28, 4, line);	
					register_idx++;			
				}
				else if(register_idx == 2)
				{
					if(iss_idx == 0)
					{
						instruction.replace(28, 4, line);
						instruction.replace(24, 1, "0");
						instruction.replace(27, 1, "1");
					}
					else instruction.replace(20, 4, line);	
					register_idx++;			
				}
				else
				{
					if(iss_idx == 0)
					{
						instruction.replace(20, 4, line);
						instruction.replace(6, 1, "0");
					}
					else instruction.replace(16, 4, line);	
					register_idx++;					
				}
			}
			else if (line == "S")
			{
				instruction.replace(11, 1, "1");
			}
			else
			{
				line.erase(0,1);
				register_int = atoi(line.c_str());
				if(ror_idx)
				{
					std::bitset< 4 >bitset_register(register_int);
					line = bitset_register.to_string< char,std::string::traits_type,std::string::allocator_type >();
					instruction.replace(20, 4, line);
				}
				else if(register_idx == 2)
				{
					instruction.replace(6, 1, "1");
					std::bitset< 8 >bitset_register(register_int);
					line = bitset_register.to_string< char,std::string::traits_type,std::string::allocator_type >();
					instruction.replace(24, 8, line);
				}
				else
				{
					std::bitset< 5 >bitset_register(register_int);
					line = bitset_register.to_string< char,std::string::traits_type,std::string::allocator_type >();
					instruction.replace(20, 5, line);
					instruction.replace(27, 1, "0");
				}
			}
		}
		fi.close();
	}
	std::cout << instruction << '\n';
	fo << "@" << ((instruction_idx-1)*4)<< " " << instruction;
	fo.close();
 return 0;
}