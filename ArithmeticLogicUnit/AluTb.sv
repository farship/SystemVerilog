`timescale 1ns / 1ps

import InstructionSetPkg::*;

// This module implements a set of tests that 
// partially verify the ALU operation.
module AluTb();

	eOperation Operation;
	
	sFlags    InFlags;
	sFlags    OutFlags;
	
	logic signed [ImmediateWidth-1:0] InImm = '0;
	
	logic	signed [DataWidth-1:0] InSrc  = '0;
	logic signed [DataWidth-1:0] InDest = '0;
	
	logic signed [DataWidth-1:0] OutDest;

	ArithmeticLogicUnit uut (.*);

	initial
	begin
		InFlags = sFlags'(0);
		
		
		$display("Start of NAND tests");
		Operation = NAND;
		
		InDest = 16'h0000;
		InSrc  = 16'hA5A5;      
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h5A5A) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h1234; 
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h0000;   
		InDest = 16'hA5A5;     
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h9999;  
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'hFFFF; 
	   #1 if (OutDest != 16'h5A5A) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h1234;  
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		#50;

				
		
		$display("Start of ADC tests");
		Operation = ADC;
		
		InDest = 16'h0000;
		InSrc = 16'hA5A5;   
	   #1 
		if (OutDest != 16'hA5A5) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'ha5a6) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);

		#10 InDest = 16'h5A5A; 
	   #1 
		if (OutDest != 16'h0000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(11)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h8000;
		InFlags.Carry = '0;
		InSrc = 16'hffff;      
	   #1 
		if (OutDest != 16'h7fff) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(17)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h7fff;
		InSrc = 16'h0001;     
	   #1 
		if (OutDest != 16'h8000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(20)) $display("Error (flags) in ADC operation at time %t",$time);
		#50;

		
		$display("Start of LIU tests");
		Operation = LIU;
		
		InDest = 16'h0000;
		InImm = 6'h3F;          
	   #1 if (OutDest != 16'hF800) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h0F;      
	   #1 if (OutDest != 16'h03C0) $display("Error in LIU operation at time %t",$time);
		
		#10 InDest = 16'hAAAA;  		
	   #1 if (OutDest != 16'h03EA) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h3F;      
	   #1 if (OutDest != 16'hFAAA) $display("Error in LIU operation at time %t",$time);
		#50;
	

		// Put your code here to verify the instructions.

		$display("Start of NOR tests");
		Operation = NOR;
		
		InDest = 16'h0000;
		InSrc  = 16'hA5A5;      
	   #1 if (OutDest != 16'h5A5A) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h4242) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h0000) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'h1234; 
	   #1 if (OutDest != 16'h484A) $display("Error in NOR operation at time %t",$time);
	   #50
		

		$display("Start of ROL tests");
		Operation = ROL;
		
		InFlags.Carry = 0;
		InSrc  = 16'hA5A5;      
	   #1 if (OutDest != 16'h4B4A) $display("Error in ROL operation at time %t",$time);
	   	  if (OutFlags.Carry != 1) $display("Error (flags) in ROL operation at time %t",$time);
		
		#10 InSrc = 16'h9999; 
	   #1 if (OutDest != 16'h3332) $display("Error in ROL operation at time %t",$time);
	      if (OutFlags.Carry != 1) $display("Error (flags) in ROL operation at time %t",$time);
		
		#10 InSrc = 16'h643E; 
	   #1 if (OutDest != 16'hC87C) $display("Error in ROL operation at time %t",$time);
	      if (OutFlags.Carry != 0) $display("Error (flags) in ROL operation at time %t",$time);
		
		#10 InSrc = 16'h0000; 
			InFlags.Carry = 1;
	   #1 if (OutDest != 16'h0001) $display("Error in ROL operation at time %t",$time);
	      if (OutFlags.Carry != 0) $display("Error (flags) in ROL operation at time %t",$time);

		#10 InSrc = 16'hA113; 
		#1 if (OutDest != 16'h4227) $display("Error in ROL operation at time %t",$time);
	      if (OutFlags.Carry != 1) $display("Error (flags) in ROL operation at time %t",$time);
		#50;


		$display("Start of ROR tests");
		Operation = ROR;
		
		InFlags.Carry = 0;
		InSrc  = 16'hA5A5;      
	   #1 if (OutDest != 16'h52D2) $display("Error in ROR operation at time %t",$time);
	   	  if (OutFlags.Carry != 1) $display("Error (flags) in ROR operation at time %t",$time);
		
		#10 InSrc = 16'h9999; 
	   #1 if (OutDest != 16'h4CCC) $display("Error in ROR operation at time %t",$time);
	      if (OutFlags.Carry != 1) $display("Error (flags) in ROR operation at time %t",$time);
		
		#10 InSrc = 16'h643E; 
	   #1 if (OutDest != 16'h321F) $display("Error in ROR operation at time %t",$time);
	      if (OutFlags.Carry != 0) $display("Error (flags) in ROR operation at time %t",$time);
		
		#10 InSrc = 16'h0000; 
			InFlags.Carry = 1;
	   #1 if (OutDest != 16'h8000) $display("Error in ROR operation at time %t",$time);
	      if (OutFlags.Carry != 0) $display("Error (flags) in ROR operation at time %t",$time);

		#10 InSrc = 16'hA113; 
		#1 if (OutDest != 16'hD089) $display("Error in ROR operation at time %t",$time);
	      if (OutFlags.Carry != 1) $display("Error (flags) in ROR operation at time %t",$time);
		
		#10 InSrc = 16'h1234;
		#1 if (OutDest != 16'h891A) $display("Error in ROR operation at time %t",$time);
	      if (OutFlags.Carry != 0) $display("Error (flags) in ROR operation at time %t",$time);
		#50;


		$display("Start of SUB tests");
		Operation = SUB;

		InFlags.Carry = '0;
		InDest = 16'hA5A5;
		InSrc = 16'h0000;
	   #1 
		if (OutDest != 16'hA5A5) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in SUB operation at time %t",$time);
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'ha5a4) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(4)) $display("Error (flags) in SUB operation at time %t",$time);

		#10 InSrc = 16'hA5A5; 
	   #1 
		if (OutDest != 16'hFFFF) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(13)) $display("Error (flags) in SUB operation at time %t",$time);
		
		#10 InFlags.Carry = '0;
		InSrc = 16'hA5A5;      
	   #1 
		if (OutDest != 16'h0000) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(26)) $display("Error (flags) in SUB operation at time %t",$time);
		
		#10 InDest = 16'h7fff;
		InSrc = 16'h0f15;     
	   #1 
		if (OutDest != 16'h70EA) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(8)) $display("Error (flags) in SUB operation at time %t",$time);
		#50;



		// End of instruction simulation


		$display("End of tests");
	end
endmodule
