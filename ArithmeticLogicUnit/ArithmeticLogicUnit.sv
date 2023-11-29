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
		OutFlags  = InFlags;
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		case(Operation)		
		
			ROL:     {OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry};	
			
			NAND:    OutDest = ~(InSrc & InDest);

			LIL:	 OutDest = $signed(InImm);

			LIU:
				begin
					if (InImm[ImmediateWidth - 1] ==  1)
						OutDest = {InImm[ImmediateWidth - 2:0], InDest[ImmediateHighStart - 1:0]};
					else if  (InImm[ImmediateWidth - 1] ==  0)	
						OutDest = $signed({InImm[ImmediateWidth - 2:0], InDest[ImmediateMidStart - 1:0]});
					else
						OutDest = InDest;	
				end


			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			// Put your instruction implementations here.
			NOR:	OutDest = ~(InSrc | InDest);

			ROR:	{OutDest,OutFlags.Carry} = {InFlags.Carry,InSrc};

			MOVE:	OutDest = InSrc;

			ADC:
				begin	
					{OutFlags.Carry,OutDest} = InSrc + InDest + InFlags.Carry;
					if (OutDest == 0) OutFlags.Zero = 1;
					else OutFlags.Zero = 0;
					// OutFlags.NotZero = (OutDest != 0); // NZ
					if (OutDest[DataWidth-1]) OutFlags.Negative = 1; // have to check if the input is signed?
					else OutFlags.Negative = 0;
					OutFlags.Overflow = (InDest[DataWidth-1] == InSrc[DataWidth-1]) & (OutDest[DataWidth-1] != InDest[DataWidth-1]); // OVERFLOW
					OutFlags.Parity = ~(^OutDest); // need to have a ~ bitwise XOR of the output 
					// OutFlags.Always = 1;
				end
			
			SUB:
				begin
					{OutFlags.Carry,OutDest} = InDest - (InSrc + InFlags.Carry); // ANS & C
					// if (OutDest == 0) OutFlags.Zero = 1; // Z
					// else OutFlags.Zero = 0;
					OutFlags.Zero = (OutDest == 0); // Z
					// OutFlags.NotZero = (OutDest != 0); // NZ
					// if (OutDest[DataWidth-1]) OutFlags.Negative = 1;
					// else OutFlags.Negative = 0;
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Overflow = (InDest[DataWidth-1] == InSrc[DataWidth-1]) & (OutDest[DataWidth-1] != InDest[DataWidth-1]); // OVERFLOW
					OutFlags.Parity = ~(^OutDest);
					// OutFlags.Always = 1;
				end
			
			DIV:
				begin
					OutDest = $signed(InDest / InSrc);
					OutFlags.Zero = (OutDest == 0); // Z
					// OutFlags.NotZero = (OutDest != 0); // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest);
					// OutFlags.Always = 1;
				end
			MOD:
				begin
					OutDest = InDest % InSrc;
					OutFlags.Zero = (OutDest == 0); // Z
					// OutFlags.NotZero = (OutDest != 0); // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest);
					// OutFlags.Always = 1;
				end
			MUL:
				begin
					OutDest = $signed(InDest*InSrc);
					OutDest = OutDest[(DataWidth/2)-1:0];
					OutFlags.Zero = (OutDest == 0); // Z
					// OutFlags.NotZero = (OutDest != 0); // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest);
					// OutFlags.Always = 1;
				end
			MUH:
				begin
					OutDest = $signed(InDest*InSrc);
					OutDest = OutDest[DataWidth-1:(DataWidth/2)];
					OutFlags.Zero = (OutDest == 0); // Z
					// OutFlags.NotZero = (OutDest != 0); // NZ
					OutFlags.Negative = OutDest[DataWidth-1]; // N
					OutFlags.Parity = ~(^OutDest);
					// OutFlags.Always = 1;
				end
			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	OutDest = '0;
			
		endcase;
	end

endmodule