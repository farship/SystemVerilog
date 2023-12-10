// RegisterFileTestBench
//
// Uriel Martinez-Hernandez
//
// This module test the functionality of the Register File


module RegisterFileTb();
	logic        Clock = 0;
	logic [5:0]  AddressA;
	logic [15:0] ReadDataA;
	logic [15:0] WriteData;
	logic        WriteEnable;
	logic [5:0]  AddressB;
	logic [15:0] ReadDataB;
	
	RegisterFile uut 
	(
		.*
		/*.Clock,
		.AddressA,
		.ReadDataA,
		.WriteData,
		.WriteEnable,
		.AddressB,
		.ReadDataB*/
	);

	default clocking @(posedge Clock);
	endclocking
	
	always  #10  Clock = ~Clock;
	
	
	initial 
	begin
		
	Clock = '0;
	AddressA = '0;
	WriteData = '0;
	WriteEnable = '0;
	AddressB = '0;
	
	##2; // do nothing
	##1 AddressA = 6'b00_1011; // going to write here
		WriteData = 16'h1ff4; // data to write
	##1 WriteEnable = '1; // write
	##1 WriteEnable = '0;
		WriteData = 16'h0040; // don't write this but still assign to the input
	##1 AddressA = 6'b00_1001; // write here
		WriteData = 16'h1234; // write this
	##1 WriteEnable = '1; // write
	##1 AddressA = 6'b11_1011; // test writing the same data to different addresses on the next clock cycle
	##1 WriteEnable = '0;
	##1 WriteData = 16'h0041;
	##1 AddressA = 6'b00_1011; // was it saved to the register
	##1;
	
	
	
	end
	
	
	
	
	
	
endmodule
