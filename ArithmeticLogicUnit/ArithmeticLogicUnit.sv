// ArithmeticLogicUnit
// This is a basic implementation of the essential operations needed
// in the ALU. Adding futher instructions to this file will increase 
// your marks.

// Load information about the instruction set. 
import InstructionSetPkg::*;

// Define the connections into and out of the ALU.
module ArithmeticLogicUnit
(
	// The Operation variable is an example of an enumerated type and
	// is defined in InstructionSetPkg.
	input eOperation Operation,
	
	// The InFlags and OutFlags variables are examples of structures
	// which have been defined in InstructionSetPkg. They group together
	// all the single bit flags described by the Instruction set.
	input  sFlags    InFlags,
	output sFlags    OutFlags,
	
	// All the input and output busses have widths determined by the 
	// parameters defined in InstructionSetPkg.
	input  signed [ImmediateWidth-1:0] InImm,
	
	// InSrc and InDest are the values in the source and destination
	// registers at the start of the instruction.
	input  signed [DataWidth-1:0] InSrc,
	input  signed [DataWidth-1:0]	InDest,
	
	// OutDest is the result of the ALU operation that is written 
	// into the destination register at the end of the operation.
	output logic signed [DataWidth-1:0] OutDest
);
	

	// This block allows each OpCode to be defined. Any opcode not
	// defined outputs a zero. The names of the operation are defined 
	// in the InstructionSetPkg. 
	always_comb
	begin
	
		// By default the flags are unchanged. Individual operations
		// can override this to change any relevant flags.
		OutFlags  = InFlags; // indicates when ALU is read to accept new inputs as Always flag can be unset
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		case(Operation)		
		
			ROL:    begin
						{OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry};	
						OutFlags.NoCarry = ~OutFlags.Carry; // NC // even though this isn't marked, the code will be consistant
						OutFlags.Always = 1; // A
					end
			
			NAND:   begin
						OutDest = ~(InSrc & InDest);
						OutFlags.Always = 1; // A
					end

			LIL:	begin
						OutDest = $signed(InImm);
						OutFlags.Always = 1; // A
					end

			LIU:
				begin
					if (InImm[ImmediateWidth - 1] ==  1)
						OutDest = {InImm[ImmediateWidth - 2:0], InDest[ImmediateHighStart - 1:0]};
					else if  (InImm[ImmediateWidth - 1] ==  0)	
						OutDest = $signed({InImm[ImmediateWidth - 2:0], InDest[ImmediateMidStart - 1:0]});
					else
						OutDest = InDest;	
					OutFlags.Always = 1; // A
				end


			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			// Put your instruction implementations here.

			NOR:	begin
						OutDest = ~(InSrc | InDest);
						OutFlags.Always = 1; // A
					end

			ROR:	begin
						{OutDest,OutFlags.Carry} = {InFlags.Carry,InSrc};
						OutFlags.NoCarry = ~OutFlags.Carry; // NC
						OutFlags.Always = 1; // A
					end

			MOVE:	begin
						OutDest = InSrc;
						OutFlags.Always = 1; // A
					end
					
			ADC:
				begin	
					{OutFlags.Carry,OutDest} = InSrc + InDest + InFlags.Carry;
					if (OutDest == 0) OutFlags.Zero = 1;
					else OutFlags.Zero = 0;
					OutFlags.NotZero = ~OutFlags.Zero; // NZ
					if (OutDest[DataWidth-1]) OutFlags.Negative = 1; // have to check if the input is signed?
					else OutFlags.Negative = 0;
					OutFlags.Overflow = (InDest[DataWidth-1] == InSrc[DataWidth-1]) & (OutDest[DataWidth-1] != InDest[DataWidth-1]); // OVERFLOW
					OutFlags.Parity = ~(^OutDest); // P // need to have a ~ bitwise XOR of the output 
					OutFlags.Always = 1; // A
					OutFlags.NoCarry = ~OutFlags.Carry; // NC
				end
			
			SUB:
				begin
					{OutFlags.Carry,OutDest} = InDest - (InSrc + InFlags.Carry); // ANS & C
					OutFlags.Zero = (OutDest == 0); // Z
					OutFlags.NotZero = ~OutFlags.Zero; // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Overflow = (InDest[DataWidth-1] == InSrc[DataWidth-1]) & (OutDest[DataWidth-1] != InDest[DataWidth-1]); // OVERFLOW
					OutFlags.Parity = ~(^OutDest); // P
					OutFlags.Always = 1; // A
					OutFlags.NoCarry = ~OutFlags.Carry; // NC
				end
			
			DIV:
				begin
					OutDest = $signed(InDest / InSrc);
					OutFlags.Zero = (OutDest == 0); // Z
					OutFlags.NotZero = ~OutFlags.Zero; // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest); // P
					OutFlags.Always = 1; // A
				end
			MOD:
				begin
					OutDest = $signed(InDest % InSrc);
					OutFlags.Zero = (OutDest == 0); // Z
					OutFlags.NotZero = ~OutFlags.Zero; // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest); // P
					OutFlags.Always = 1; // A
				end
			MUL:
				begin
					OutDest = ($signed(InDest*InSrc));
					OutDest = OutDest[DataWidth-1:0]; // May be redundant, but don't want to risk issues in compilation in other software
					OutFlags.NotZero = ~OutFlags.Zero; // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest); // P
					OutFlags.Always = 1; // A
					OutFlags.Zero = (OutDest == 0); // Z
				end
			MUH:
				begin
					logic signed [(DataWidth*2)-1:0] DWORDAnswer; // so it doesn't loose the high half, would put out of case, but then isn't marked
					DWORDAnswer = (InDest*InSrc); // both inputs are signed, also causes sign extension wrong
					OutDest = DWORDAnswer[(2*DataWidth)-1:DataWidth];
					OutFlags.Zero = (OutDest == 0); // Z
					OutFlags.NotZero = ~OutFlags.Zero; // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest); // P
					OutFlags.Always = 1; // A
				end



			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	OutDest = '0;
			
		endcase;
	end

endmodule
