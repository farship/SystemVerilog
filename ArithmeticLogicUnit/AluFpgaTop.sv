// AluFpgaTop.sv
// C T Clarke
// 10/10/17
//
// This file implements an environment that the module
// ArithmeticLogicUnit can sit in order to work on the 
// DE1-SoC

// This package defines Opcodes and Flag structures.
// Ensure that DataWidth in this package is set to 4 
// to allow hardware implementation.
import InstructionSetPkg::*;

// Signed Decoder
// This module takes a 4 bit input and produces the signals
// required to output it as a value in the range -8 to 7 on 
// a pair of seven segment LED displays. It is assumed that
// LEDs are active low.
module SignedDecoder 
(
	input	  signed	[3:0] Value,
	output 	logic [6:0] Upper,
	output 	logic [6:0] Lower
);

	always_comb
	begin
		case (Value)
			-8: 		{Upper,Lower} = ~(14'b10000001111111);
			-7: 		{Upper,Lower} = ~(14'b10000000000111);
			-6: 		{Upper,Lower} = ~(14'b10000001111101);
			-5: 		{Upper,Lower} = ~(14'b10000001101101);
			-4: 		{Upper,Lower} = ~(14'b10000001100110);
			-3: 		{Upper,Lower} = ~(14'b10000001001111);
			-2: 		{Upper,Lower} = ~(14'b10000001011011);
			-1: 		{Upper,Lower} = ~(14'b10000000000110);
			 0: 		{Upper,Lower} = ~(14'b00000000111111);
			 1: 		{Upper,Lower} = ~(14'b00000000000110);
			 2: 		{Upper,Lower} = ~(14'b00000001011011);
			 3: 		{Upper,Lower} = ~(14'b00000001001111);
			 4: 		{Upper,Lower} = ~(14'b00000001100110);
			 5: 		{Upper,Lower} = ~(14'b00000001101101);
			 6:		{Upper,Lower} = ~(14'b00000001111101);
			 7: 		{Upper,Lower} = ~(14'b00000000000111);
			default:	{Upper,Lower} = ~(14'b00000000000000);
		endcase
	end
endmodule

// This module connects the ArithmeticLogicUnit to the LEDs 
// and switches on the DE1-SoC.
module AluFpgaTop
(
      input       [9:0]  SW,
      input       [3:0]  KEY,
      output      [6:0]  HEX5,HEX4,HEX3,HEX2,HEX1,HEX0,
      output      [9:0]  LEDR
);
  // OutDest is the output of the ALU that is fed to a 
  // decoder for display
  logic signed [3:0] OutDest;

	ArithmeticLogicUnit ALU
	(
		.Operation(eOperation'(~KEY)),
		
		.InFlags({3'd0,SW[1:0]}),
		.OutFlags(LEDR[4:0]),
		
		.InImm(SW[1:0]),
		
		.InSrc(SW[5:2]),
		.InDest(SW[9:6]),
		
		.OutDest(OutDest)
	);
	
	// These modules convert 4 bit numbers to a signed 
	// display.
	SignedDecoder Src    (SW[5:2],HEX1,HEX0);
	SignedDecoder Dest   (SW[9:6],HEX3,HEX2);
	SignedDecoder Result (OutDest,HEX5,HEX4);

endmodule
