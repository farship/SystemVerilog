
module VgaController
(
	input	logic	Clock,   // 50 MHz
	input	logic	Reset,   // hCount, VCount = 0
	output	logic	blank_n, // (Display) Active Low when out of drawing area, 1 when in
	output	logic	sync_n,  // (Sync Pulse) Active Low when H/V Sync are active
	output	logic	hSync_n, // Low when in sync pulse, hC(856-975)
	output	logic 	vSync_n, // Low when in sync pulse, vC(637-642)
	output	logic	[10:0] nextX, // == hCount when <800, 0 otherwise
	output	logic	[ 9:0] nextY  // == vCount when <600, 0 otherwise
);

	// use this signal as counter for the horizontal axis 
	logic [10:0] hCount; // if 1040, then hCount = 0

	// use this signal as counter for the vertical axis
	logic [ 9:0] vCount; // if 666, then vCount = 0
		// increments when hCount has finished a line
	
	
	// add here your code for the VGA controller
	// Timings (from 0) for Synchronisation in Pixel Clocks H then V
	// Display : 799
	// Front Porch : 56 (855)
	// Sync Pulse : 120 (975)
	// Back Porch : 64 (1039)
	// Vertical
	// Display : 599
	// Front Porch : 37 (636)
	// Sync Pulse : 6 (642)
	// Back Porch : 23 (665)

	always_comb begin : Checks
		if ((hCount >= 856) & (hCount < 976)) begin
			hSync_n = 0; // Active low when in sync range
		end
		else begin
			hSync_n = 1; // High when out of sync range
		end
		if ((vCount >= 637) & (vCount < 643)) begin
			vSync_n = 0; // Active low when in sync range
		end
		else begin
			vSync_n = 1; // High when out of range
		end
		
		sync_n = (hSync_n & vSync_n); // Outputs 0 only when in sync range for x and/or y

		if ((hCount > 799) | (vCount > 599)) begin
			blank_n = 0; // Active low when out of drawing range
		end
		else begin
			blank_n = 1; // High when in drawing range, doesn't ignore RGB
		end
	end

	always_ff @(posedge Clock, posedge Reset) begin : Counts
		if (Reset) begin
			hCount = 0;
			vCount = 0;
		end
		else begin
			if (hCount < 800) begin
				nextX = hCount; // If not completed a line then use next x-pos
			end
			else begin
				nextX = 0; // End of drawing area x met, return to start of line
			end
			if (vCount < 600) begin // If not completed a screen then use next y-pos
				nextY = vCount;
			end
			else begin
				nextY = 0; // End of drawing area y met, return to top
			end
			if (hCount < 1039) begin // if not completed a line, increment x-pos
				hCount ++;
			end
			else begin
				hCount = 0; // End of line met, return to start of line
				if (vCount < 665) begin // Only when the horizontal line is completed does the vCount increment
					vCount ++;
				end
				else begin
					vCount = 0; // Set to 0 when bottom of screen is reached
				end
			end
		end
	end

	// always_ff @( posedge Reset ) begin : reset // Asynchronous Reset
	// 		hCount = 0;
	// 		vCount = 0;
	// end

endmodule