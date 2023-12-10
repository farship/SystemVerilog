// top module to connect the VGA controller to the VGA port and monitor
//
// This file displays a pattern of colours in the monitor
//
// Uriel Martinez-Hernandez
// November 2022



module VgaTopFPGA
(
	input CLOCK_50,
	input [3:0] KEY,
	output logic VGA_CLK,
	output logic VGA_BLANK_N,
	output logic VGA_SYNC_N,
	output logic VGA_HS,
	output logic VGA_VS,
	output logic [ 7:0] VGA_R,
	output logic [ 7:0] VGA_G,
	output logic [ 7:0] VGA_B
);

	assign VGA_CLK = ~CLOCK_50;


	logic [10:0] x;
	logic [ 9:0] y;
	
	
// instantiation of the VGA controller	
	VgaController vgaDisplay
	(
		.Clock(CLOCK_50),
		.Reset(~KEY[0]),
		.blank_n(VGA_BLANK_N),
		.sync_n(VGA_SYNC_N),
		.hSync_n(VGA_HS),
		.vSync_n(VGA_VS),
		.nextX(x),
		.nextY(y)
	);
	

// this shows a pattern of colours in the screen

	always_ff @(posedge CLOCK_50)
	begin
		VGA_R = {4{x[6:5]}};
		VGA_G = {4{y[6:5]}};
		VGA_B = {4{x[4],y[4]}};
	end

endmodule