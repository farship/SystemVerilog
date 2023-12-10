// VGA controller testbench

module VgaTb();

	logic Clock;
	logic Reset;
	logic blank_n;
	logic sync_n;
	logic hSync_n;
	logic vSync_n;
	logic [10:0] nextX;
	logic [ 9:0] nextY;



	// Connect the VGA chip clock to a 
	// 50MHz clock
	default clocking @(posedge Clock);
	endclocking
	always  #10  Clock++;

	
	// Reset the module and start the clock
	initial
	begin
		Clock = '0;

		Reset = '1;
		
		##2
		
		Reset = '0;
		
		##2;
		#100000
		Reset = '1;
		##2
		Reset = '0;
		##2;
	end


	// Instantiate the VGA controller
	VgaController uut (.*);

endmodule