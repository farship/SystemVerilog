module RegisterFile
(
	input Clock, WriteEnable,
	input [5:0] AddressA, AddressB,
	input [15:0] WriteData,
	output [15:0] ReadDataA, ReadDataB
);

	bit [15:0] Registers [64]; // 64 x 16-bit Registers
	
	
	always_ff @(posedge Clock) begin // SHOULD BE WRITEABLE BE POSEDGE? MAY BE NOT DESIREABLE AS CAN WRITE TO MULTIPLE REGISTERS WITHOUT TOGGLING WRITE ENABLE
		if (WriteEnable) begin // allows WriteEnable to be left on and still write to an address on the next clock cycle
			Registers[AddressA] <= WriteData; // writing is synchronous
		end
	end
	
	assign ReadDataA = Registers[AddressA]; // asynchronous
	assign ReadDataB = Registers[AddressB]; // asynchronous
	
	
endmodule