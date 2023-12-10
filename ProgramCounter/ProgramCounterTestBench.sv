// ProgramCounterTestBench
//
//
// This module implements a testbench for 
// the Program Counter to be created in the
// Digital Systems Design tutorial.
// 
// You need to add the code to test the
// functionality of your PC
//

module ProgramCounterTestBench();

	// These are the signals that connect to 
	// the program counter
	logic              	Clock = '0;
	logic              	Reset = '0;
	logic signed       [15:0]	LoadValue;
	logic				LoadEnable = '0;
	logic signed  [8:0]	Offset;
	logic 					OffsetEnable = '0;
	logic signed  [15:0]	CounterValue;
	// logic One = '1;

	// this is another method to create an instantiation
	// of the program counter
	ProgramCounter uut
	(
		.Clock,
		.Reset,
		.LoadValue,
		.LoadEnable,
		.Offset,
		.OffsetEnable,
		.CounterValue
	);
	

	default clocking @(posedge Clock);
	endclocking
		
	always  #10  Clock = ~Clock;

	initial
	begin

		##2 Reset = '0;
			LoadEnable = '0;
			OffsetEnable = '0;
			LoadValue = 16'd0;
			Offset = 9'd0;
		##1;
		##1 Reset = '1;
		##1 Reset = '0;
		##6; // incrementing from 0
		##1 Reset = '1; // resetting to 0
		##1 Reset = '0;
			LoadValue = 16'd2023; // test not loading
		##1 LoadEnable = '1; // load
		##1 LoadEnable = '0;
		##4; // increment after load
		##2 Offset = 9'd5;
			OffsetEnable = '1; // setting offset
		##5; // increment with offset
		##1 Reset = '1; // reset with offset enabled
		##1 Reset = '0;
		##5; // Increment by offset after a reset
		##1 Reset = '1;
		##1 Reset = '0;
			OffsetEnable = '0;
		##5;
	
	end
endmodule
	
