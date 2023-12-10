// ProgramCounter in FPGA
//
// Uriel Martinez-Hernandez
//
// November 2022
//
// This module links the PC with the FPGA standard pins
//
module PcFpgaTop
(
	input       [9:0]  SW,
	input       [3:0]  KEY,
	output      [9:0]  LEDR,
	output      [6:0]  HEX4,HEX3,HEX2,HEX1,HEX0
);
 
	logic [15:0] PcValue;
   logic [6:0]  Segments [5:0];
	
	DecimalDisplayFiveDigit DDFD 
	(
		PcValue, 
		Segments
	);

	assign HEX0 = Segments[0];
	assign HEX1 = Segments[1];
	assign HEX2 = Segments[2];
	assign HEX3 = Segments[3];
	assign HEX4 = Segments[4];
	assign LEDR = SW;
	

	// instantiation of PC and connection of input and output ports
	// use these switches and push buttons for testing your module in hardware
	ProgramCounter PC
	(
		.Clock(~KEY[0]),
		.Reset(~KEY[1]),
		.LoadValue({SW,6'd0}),
		.LoadEnable(~KEY[2]),
		.Offset(SW[8:0]),
		.OffsetEnable(~KEY[3]),
		.CounterValue(PcValue)
	);

endmodule



// SevenSegmentDecoder: A full hexadecimal 
// decoder for a seven segment display. If
// the blank input is high, the output is 
// switched off. Setting the ActiveValue
// parameter to 0 will make the output 
// active low.

module SevenSegmentDecoder 
#(
	parameter				ActiveValue = 0
)
(
	input		[3:0] Value,
	input 		 	Blank,
	output 	[6:0] SegmentsOut
);
	reg	[6:0] Segments;

	always @*
	begin
		case ({Blank,Value})
			0: 		Segments = 7'b0111111;
			1: 		Segments = 7'b0000110;
			2: 		Segments = 7'b1011011;
			3: 		Segments = 7'b1001111;
			4: 		Segments = 7'b1100110;
			5: 		Segments = 7'b1101101;
			6:			Segments = 7'b1111101;
			7: 		Segments = 7'b0000111;
			8: 		Segments = 7'b1111111;
			9: 		Segments = 7'b1101111;
			10: 		Segments = 7'b1110111;
			11: 		Segments = 7'b1111100;
			12: 		Segments = 7'b0111001;
			13: 		Segments = 7'b1011110;
			14: 		Segments = 7'b1111001;
			15: 		Segments = 7'b1110001;
			default:	Segments = 7'b0000000;
		endcase
	end

	assign SegmentsOut = (ActiveValue == 1) ? Segments : ~Segments;
endmodule
	
// A five digit Decimal display decoder.
// This module codes the individual digits fro th seven segment display
module DecimalSegmentDecoder 
(
	input		[3:0] Value,
	input 		 	Blank,
	output 	[6:0] SegmentsOut
);
	logic	   [6:0] Segments;
  
	always @*
	begin
		case ({Blank,Value})
			0: 		Segments = 7'b0111111;
			1: 		Segments = 7'b0000110;
			2: 		Segments = 7'b1011011;
			3: 		Segments = 7'b1001111;
			4: 		Segments = 7'b1100110;
			5: 		Segments = 7'b1101101;
			6:			Segments = 7'b1111101;
			7: 		Segments = 7'b0000111;
			8: 		Segments = 7'b1111111;
			9: 		Segments = 7'b1101111;
			default:	Segments = 7'b0000000;
		endcase
	end

	assign SegmentsOut = ~Segments;
endmodule
	

// This module separates the digits from one another 
module DecimalDisplayFiveDigit 
(
	input  [15:0] 	   Value, 
	output [6:0]      Segments [5:0] 
);

	logic 	[15:0] Divide[4];
	logic 	[3:0]	 Digit[5];
	logic 	[5:0]  Blank;

	
	always_comb
	begin
	
	   // Divide value repeatedly by 10 to get each digit
		Divide[0] = Value / 4'd10;
		Digit[0]  = Value % 4'd10;
		
		for (int i = 1; i <= 3; i++)
		begin
			Divide[i] = Divide[i-1] / 4'd10;
	      Digit[i]  = Divide[i-1] % 4'd10;
		end
	   Digit[4]  = Divide[3] % 4'd10;
		
		// Set the blanking conditions
		Blank[5] = '1;
		
		for (int i = 4; i > 0; i--)
		begin
			Blank[i] = (Digit[i] == 0) ? Blank[i+1] : '0;
		end
		
		Blank[0] = '0;
	end
	
	// Set up the seven segment decoders
	generate
		genvar i;
		for (i=0; i < 5; i++)
		begin: digit
			DecimalSegmentDecoder decoder0 (Digit[i][3:0],Blank[i],Segments[i]);
	   end
	endgenerate

endmodule

