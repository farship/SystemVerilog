// InstructionSetPkg
//
// Uriel Martinez-Hernandez
// (acknowledgements to C T Clarke)
//
// 1/11/18
//
// This package is used to define all the values and types 
// needed for the highRisc instruction set.

package InstructionSetPkg;
 
   // CHANGE THIS PARAMETER to 4 for testing the ALU on the 
	// FPGA. This is because the hardware doesn't have enough
	// switches. For simulation, and the overall processor 
	// configuration, set the value to 16.
	parameter DataWidth       = 4;
	
	// An example of an enumerated type that defines the names
	// for all of the instruction set opcodes.
	typedef enum logic [3:0]
	// $ : Implemented
	// % : Tested
	{
		JR    = 4'd0,  // not alu
		LOAD  = 4'd1,  // not alu
		STORE = 4'd2,  // not alu
		MOVE  = 4'd3,  // $ cp src dest // not tested; given; flags have been added
		NAND  = 4'd4,  // $ %
		NOR   = 4'd5,  // $ %
		ROL   = 4'd6,  // $ % : C NC
		ROR   = 4'd7,  // $ %: C
		LIL   = 4'd8,  // $ // not tested as the instruction was provided, though flags have been added
		LIU   = 4'd9,  // $ %
		ADC   = 4'd10, // $ % dest = src+dest+c : CZNVP
		SUB   = 4'd11, // $ % dest = dest - (src+c) : CZNVP
		DIV   = 4'd12, // $ % dest = signed (dest/src) : ZNP
		MOD   = 4'd13, // $ % dest = dest % src : ZNP
		MUL   = 4'd14, // $ % dest = lower  half of signed(dest*src) : ZNP
		MUH   = 4'd15  // $ % dest = higher half of signed(dest*src) : ZNP
	} eOperation;

	// A : Always : 128
	// NZ: Not Zero : 64
	// NC: No Carry : 32
	// V : Overflow : 16
	// P : Parity : 8
	// N : Negative : 4
	// Z : Zero : 2
	// C : Carry : 1


	// An example of a structure used to combine the different
	// flags together so they can be refered to as a group.
	typedef struct packed
	{
		logic Always;
		logic NotZero;
		logic NoCarry;
		logic Overflow;
		logic Parity;
		logic Negative;
		logic Zero;
		logic Carry;
	} sFlags;
  
	// This setup works well for dataWidth values of 4 and 16
	// It is not tested for other values
	parameter ImmediateWidth     =    DataWidth/3  + DataWidth%3;
	parameter ImmediateMidStart  =    DataWidth/3  + DataWidth%3;
	parameter ImmediateHighStart = 2*(DataWidth/3) + DataWidth%3;

	// Sizes of various busses and bit positions
	parameter AddressWidth    = 16;
	parameter RfAddressWidth  =  6;
	parameter MemAddressWidth = 16;
	parameter OffsetWidth     =  9;
	parameter OpCodeStart     = 12;
	parameter OpCodeSize      =  4;
	parameter RegAStart       =  6;
	parameter RegASize        =  6;
	parameter RegBStart       =  0;
	parameter RegBSize        =  6;
	
	// The Register numbers of the flags and program counter
	// registers.
	typedef enum {SPECIAL_PC = 63,SPECIAL_FL = 62} eSpecials;

endpackage
