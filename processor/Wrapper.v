`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (CLK100MHZ, BTNC, BTNR, LED, hSync, vSync, VGA_B, VGA_G, VGA_R, SW, JA, JB, JC, JD);
	input CLK100MHZ, BTNC, BTNR;
	input[15:0] SW;
	input[11:0] JA, JB, JC, JD;
	output[15:0] LED;
	output vSync; 		// H Sync Signal
	output hSync; 		// Veritcal Sync Signal
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G;  // Green Signal Bits
	output[3:0] VGA_B;  // Blue Signal Bits

	wire rwe, mwe, clock, reset;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut, pc, 
		reg26, reg27, reg28, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg17, reg18;
		
	reg CLK50MHZ = 1'b0;
	always @(posedge CLK100MHZ) begin
	   CLK50MHZ = ~CLK50MHZ;
	end
	
	assign clock = CLK50MHZ;
	assign reset = BTNC;
    
    localparam FILES_PATH = "C:/Users/bs299/Desktop/";
    
	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge CLK100MHZ) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end
	
	//VGA
    localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height
    
    VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1, // Use built in log2 Command
		CROWN_SIZE = 676,
		CROWN_DATA_WIDTH = 1,
		CROWN_ADDRESS_WIDTH = 10;

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	IRAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clock), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	IRAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clock), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	
    wire[CROWN_ADDRESS_WIDTH-1:0] crown_addr;
    wire[CROWN_DATA_WIDTH-1:0] crown_data;
    
    IRAM #(
		.DEPTH(CROWN_SIZE), 		       // Set depth to contain every color		
		.DATA_WIDTH(CROWN_DATA_WIDTH), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(CROWN_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "crown.mem"}))  // Memory initialization
	Crown(
		.clk(clock), 							   	   // Rising edge of the 100 MHz clk
		.addr(crown_addr),					       // Address from the ImageData RAM
		.dataOut(crown_data),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
    
    assign crown_addr = x + y * 26;
    
    //always @(posedge clock) begin
	  // crown_addr = x + (y * 26);
	//end

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorData : 12'd0; // When not active, output black

    wire in_square = x > 509 && x < 549 && y > 11 && y < 51 && SW[0]; 
    wire[2:0] red = 3'b010;
    wire[2:0] black = 3'b001;
    wire[2:0] redK = 3'b100;
    wire[2:0] blackK = 3'b111;
    wire in_red = (x > 89 && x < 129 && y > 11 && y < 51 && (reg19[29:27] == red || reg19[29:27] == redK)) || (x > 209 && x < 249 && y > 11 && y < 51 && (reg19[23:21] == red || reg19[23:21] == redK)) || (x > 329 && x < 369 && y > 11 && y < 51 && (reg19[17:15] == red || reg19[17:15] == redK)) || (x > 449 && x < 489 && y > 11 && y < 51 && (reg19[11:9] == red || reg19[11:9] == redK))
                || (x > 89 && x < 129 && y > 131 && y < 171 && (reg20[11:9] == red || reg20[11:9] == redK)) || (x > 209 && x < 249 && y > 131 && y < 171 && (reg20[5:3] == red || reg20[5:3] == redK)) || (x > 329 && x < 369 && y > 131 && y < 171 && (reg21[29:27] == red || reg21[29:27] == redK)) || (x > 449 && x < 489 && y > 131 && y < 171 && (reg21[23:21] == red || reg21[23:21] == redK))
                || (x > 89 && x < 129 && y > 251 && y < 291 && (reg22[23:21] == red || reg22[23:21] == redK)) || (x > 209 && x < 249 && y > 251 && y < 291 && (reg22[17:15] == red || reg22[17:15] == redK)) || (x > 329 && x < 369 && y > 251 && y < 291 && (reg22[11:9] == red || reg22[11:9] == redK)) || (x > 449 && x < 489 && y > 251 && y < 291 && (reg22[5:3] == red || reg22[5:3] == redK))
                || (x > 89 && x < 129 && y > 371 && y < 411 && (reg23[5:3] == red || reg23[5:3] == redK)) || (x > 209 && x < 249 && y > 371 && y < 411 && (reg24[29:27] == red || reg24[29:27] == redK)) || (x > 329 && x < 369 && y > 371 && y < 411 && (reg24[23:21] == red || reg24[23:21] == redK)) || (x > 449 && x < 489 && y > 371 && y < 411 && (reg24[17:15] == red || reg24[17:15] == redK))
                || (x > 149 && x < 189 && y > 71 && y < 111 && (reg19[2:0] == red || reg19[2:0] == redK)) || (x > 269 && x < 309 && y > 71 && y < 111 && (reg20[26:24] == red || reg20[26:24] == redK)) || (x > 389 && x < 429 && y > 71 && y < 111 && (reg20[20:18] == red || reg20[20:18] == redK)) || (x > 509 && x < 549 && y > 71 && y < 111 && (reg20[14:12] == red || reg20[14:12] == redK))
                || (x > 149 && x < 189 && y > 191 && y < 231 && (reg21[14:12] == red || reg21[14:12] == redK)) || (x > 269 && x < 309 && y > 191 && y < 231 && (reg21[8:6] == red || reg21[8:6] == redK)) || (x > 389 && x < 429 && y > 191 && y < 231 && (reg21[2:0] == red || reg21[2:0] == redK)) || (x > 509 && x < 549 && y > 191 && y < 231 && (reg22[26:24] == red || reg22[26:24] == redK))
                || (x > 149 && x < 189 && y > 311 && y < 351 && (reg23[26:24] == red || reg23[26:24] == redK)) || (x > 269 && x < 309 && y > 311 && y < 351 && (reg23[20:18] == red || reg23[20:18] == redK)) || (x > 389 && x < 429 && y > 311 && y < 351 && (reg23[14:12] == red || reg23[14:12] == redK)) || (x > 509 && x < 549 && y > 311 && y < 351 && (reg23[8:6] == red || reg23[8:6] == redK))
                || (x > 149 && x < 189 && y > 431 && y < 471 && (reg24[8:6] == red || reg24[8:6] == redK)) || (x > 269 && x < 309 && y > 431 && y < 471 && (reg24[2:0] == red || reg24[2:0] == redK)) || (x > 389 && x < 429 && y > 431 && y < 471 && (reg25[8:6] == red || reg25[8:6] == redK)) || (x > 509 && x < 549 && y > 431 && y < 471 && (reg25[2:0] == red || reg25[2:0] == redK));

    wire in_black = (x > 89 && x < 129 && y > 11 && y < 51 && (reg19[29:27] == black || reg19[29:27] == blackK)) || (x > 209 && x < 249 && y > 11 && y < 51 && (reg19[23:21] == black || reg19[23:21] == blackK)) || (x > 329 && x < 369 && y > 11 && y < 51 && (reg19[17:15] == black || reg19[17:15] == blackK)) || (x > 449 && x < 489 && y > 11 && y < 51 && (reg19[11:9] == black || reg19[11:9] == blackK))
                || (x > 89 && x < 129 && y > 131 && y < 171 && (reg20[11:9] == black || reg20[11:9] == blackK)) || (x > 209 && x < 249 && y > 131 && y < 171 && (reg20[5:3] == black || reg20[5:3] == blackK)) || (x > 329 && x < 369 && y > 131 && y < 171 && (reg21[29:27] == black || reg21[29:27] == blackK)) || (x > 449 && x < 489 && y > 131 && y < 171 && (reg21[23:21] == black || reg21[23:21] == blackK))
                || (x > 89 && x < 129 && y > 251 && y < 291 && (reg22[23:21] == black || reg22[23:21] == blackK)) || (x > 209 && x < 249 && y > 251 && y < 291 && (reg22[17:15] == black || reg22[17:15] == blackK)) || (x > 329 && x < 369 && y > 251 && y < 291 && (reg22[11:9] == black || reg22[11:9] == blackK)) || (x > 449 && x < 489 && y > 251 && y < 291 && (reg22[5:3] == black || reg22[5:3] == blackK))
                || (x > 89 && x < 129 && y > 371 && y < 411 && (reg23[5:3] == black || reg23[5:3] == blackK)) || (x > 209 && x < 249 && y > 371 && y < 411 && (reg24[29:27] == black || reg24[29:27] == blackK)) || (x > 329 && x < 369 && y > 371 && y < 411 && (reg24[23:21] == black || reg24[23:21] == blackK)) || (x > 449 && x < 489 && y > 371 && y < 411 && (reg24[17:15] == black || reg24[17:15] == blackK))
                || (x > 149 && x < 189 && y > 71 && y < 111 && (reg19[2:0] == black || reg19[2:0] == blackK)) || (x > 269 && x < 309 && y > 71 && y < 111 && (reg20[26:24] == black || reg20[26:24] == blackK)) || (x > 389 && x < 429 && y > 71 && y < 111 && (reg20[20:18] == black || reg20[20:18] == blackK)) || (x > 509 && x < 549 && y > 71 && y < 111 && (reg20[14:12] == black || reg20[14:12] == blackK))
                || (x > 149 && x < 189 && y > 191 && y < 231 && (reg21[14:12] == black || reg21[14:12] == blackK)) || (x > 269 && x < 309 && y > 191 && y < 231 && (reg21[8:6] == black || reg21[8:6] == blackK)) || (x > 389 && x < 429 && y > 191 && y < 231 && (reg21[2:0] == black || reg21[2:0] == blackK)) || (x > 509 && x < 549 && y > 191 && y < 231 && (reg22[26:24] == black || reg22[26:24] == blackK))
                || (x > 149 && x < 189 && y > 311 && y < 351 && (reg23[26:24] == black || reg23[26:24] == blackK)) || (x > 269 && x < 309 && y > 311 && y < 351 && (reg23[20:18] == black || reg23[20:18] == blackK)) || (x > 389 && x < 429 && y > 311 && y < 351 && (reg23[14:12] == black || reg23[14:12] == blackK)) || (x > 509 && x < 549 && y > 311 && y < 351 && (reg23[8:6] == black || reg23[8:6] == blackK))
                || (x > 149 && x < 189 && y > 431 && y < 471 && (reg24[8:6] == black || reg24[8:6] == blackK)) || (x > 269 && x < 309 && y > 431 && y < 471 && (reg24[2:0] == black || reg24[2:0] == blackK)) || (x > 389 && x < 429 && y > 431 && y < 471 && (reg25[8:6] == black || reg25[8:6] == blackK)) || (x > 509 && x < 549 && y > 431 && y < 471 && (reg25[2:0] == black || reg25[2:0] == blackK));


//    wire in_black = (x > 89 && x < 129 && y > 11 && y < 51 && reg19[29:27] == black) || (x > 209 && x < 249 && y > 11 && y < 51 && reg19[23:21] == black) || (x > 329 && x < 369 && y > 11 && y < 51 && reg19[17:15] == black) || (x > 449 && x < 489 && y > 11 && y < 51 && reg19[11:9] == black)
//                || (x > 89 && x < 129 && y > 131 && y < 171 && reg20[11:9] == black) || (x > 209 && x < 249 && y > 131 && y < 171 && reg20[5:3] == black) || (x > 329 && x < 369 && y > 131 && y < 171 && reg21[29:27] == black) || (x > 449 && x < 489 && y > 131 && y < 171 && reg21[23:21] == black)
//                || (x > 89 && x < 129 && y > 251 && y < 291 && reg22[23:21] == black) || (x > 209 && x < 249 && y > 251 && y < 291 && reg22[17:15] == black) || (x > 329 && x < 369 && y > 251 && y < 291 && reg22[11:9] == black) || (x > 449 && x < 489 && y > 251 && y < 291 && reg22[5:3] == black)
//                || (x > 89 && x < 129 && y > 371 && y < 411 && reg23[5:3] == black) || (x > 209 && x < 249 && y > 371 && y < 411 && reg24[29:27] == black) || (x > 329 && x < 369 && y > 371 && y < 411 && reg24[23:21] == black) || (x > 449 && x < 489 && y > 371 && y < 411 && reg24[17:15] == black)
//                || (x > 149 && x < 189 && y > 71 && y < 111 && reg19[2:0] == black) || (x > 269 && x < 309 && y > 71 && y < 111 && reg20[26:24] == black) || (x > 389 && x < 429 && y > 71 && y < 111 && reg20[20:18] == black) || (x > 509 && x < 549 && y > 71 && y < 111 && reg20[14:12] == black)
//                || (x > 149 && x < 189 && y > 191 && y < 231 && reg21[14:12] == black) || (x > 269 && x < 309 && y > 191 && y < 231 && reg21[8:6] == black) || (x > 389 && x < 429 && y > 191 && y < 231 && reg21[2:0] == black) || (x > 509 && x < 549 && y > 191 && y < 231 && reg22[26:24] == black)
//                || (x > 149 && x < 189 && y > 311 && y < 351 && reg23[26:24] == black) || (x > 269 && x < 309 && y > 311 && y < 351 && reg23[20:18] == black) || (x > 389 && x < 429 && y > 311 && y < 351 && reg23[14:12] == black) || (x > 509 && x < 549 && y > 311 && y < 351 && reg23[8:6] == black)
//                || (x > 149 && x < 189 && y > 431 && y < 471 && reg24[8:6] == black) || (x > 269 && x < 309 && y > 431 && y < 471 && reg24[2:0] == black) || (x > 389 && x < 429 && y > 431 && y < 471 && reg25[8:6] == black) || (x > 509 && x < 549 && y > 431 && y < 471 && reg25[2:0] == black);
                
    wire in_king = (x > 99 && x < 119 && y > 21 && y < 41 && reg19[29] == 1'b1) || (x > 219 && x < 239 && y > 21 && y < 41 && reg19[23] == 1'b1) || (x > 339 && x < 359 && y > 21 && y < 41 && reg19[17] == 1'b1) || (x > 459 && x < 479 && y > 21 && y < 41 && reg19[11] == 1'b1)
                || (x > 99 && x < 119 && y > 141 && y < 161 && reg20[11] == 1'b1) || (x > 219 && x < 239 && y > 141 && y < 161 && reg20[5] == 1'b1) || (x > 339 && x < 359 && y > 141 && y < 161 && reg21[29] == 1'b1) || (x > 459 && x < 479 && y > 141 && y < 161 && reg21[23] == 1'b1)
                || (x > 99 && x < 119 && y > 261 && y < 281 && reg22[23] == 1'b1) || (x > 219 && x < 239 && y > 261 && y < 281 && reg22[17] == 1'b1) || (x > 339 && x < 359 && y > 261 && y < 281 && reg22[11] == 1'b1) || (x > 459 && x < 479 && y > 261 && y < 281 && reg22[5] == 1'b1)
                || (x > 99 && x < 119 && y > 381 && y < 401 && reg23[5] == 1'b1) || (x > 219 && x < 239 && y > 381 && y < 401 && reg24[29] == 1'b1) || (x > 339 && x < 359 && y > 381 && y < 401 && reg24[23] == 1'b1) || (x > 459 && x < 479 && y > 381 && y < 401 && reg24[17] == 1'b1)
                || (x > 159 && x < 179 && y > 81 && y < 101 && reg19[2] == 1'b1) || (x > 279 && x < 299 && y > 81 && y < 101 && reg20[26] == 1'b1) || (x > 399 && x < 419 && y > 81 && y < 101 && reg20[20] == 1'b1) || (x > 519 && x < 539 && y > 81 && y < 101 && reg20[14] == 1'b1)
                || (x > 159 && x < 179 && y > 201 && y < 221 && reg21[14] == 1'b1) || (x > 279 && x < 299 && y > 201 && y < 221 && reg21[8] == 1'b1) || (x > 399 && x < 419 && y > 201 && y < 221 && reg21[2] == 1'b1) || (x > 519 && x < 539 && y > 201 && y < 221 && reg22[26] == 1'b1)
                || (x > 159 && x < 179 && y > 321 && y < 341 && reg23[26] == 1'b1) || (x > 279 && x < 299 && y > 321 && y < 341 && reg23[20] == 1'b1) || (x > 399 && x < 419 && y > 321 && y < 341 && reg23[14] == 1'b1) || (x > 519 && x < 539 && y > 321 && y < 341 && reg23[8] == 1'b1)
                || (x > 159 && x < 179 && y > 441 && y < 461 && reg24[8] == 1'b1) || (x > 279 && x < 299 && y > 441 && y < 461 && reg24[2] == 1'b1) || (x > 399 && x < 419 && y > 441 && y < 461 && reg25[8] == 1'b1) || (x > 519 && x < 539 && y > 441 && y < 461 && reg25[2] == 1'b1);


	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = in_king ? 12'b110111010000 : (in_black ? 12'b001100110011 : (in_red ? 12'b111100000000 : colorOut));
    
//    assign LED[0] = crown_data;
    //assign LED[3:0] = JA[10:7];
    //assign LED[7:4] = JB[10:7];
    //assign LED[11:8] = JC[10:7];
    //assign LED[15:12] = JD[10:7];
    
    //assign LED[15:0] = reg19[15:0];
    //assign LED[7:0] = reg26[7:0];
    //assign LED[14:8] = reg27[6:0];
    //assign LED[15] = reg28[0];
    //assign LED[0] = vSync;
    //assign LED[1] = hSync;
    
    //assign LED = pc[7:0];
    //assign LED = 8'b10101010;
    
    //assign LED[7:0] = reg17[7:0];
    //assign LED[15:8] = reg18[7:0];

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "checkers";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		.out_pc(pc)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		.SW(SW), .BTNR(BTNR),
		.reg26(reg26), .reg27(reg27), .reg28(reg28),
		.reg25(reg25), .reg19(reg19), .reg20(reg20), .reg21(reg21), .reg22(reg22), .reg23(reg23), .reg24(reg24),
		.reg17(reg17), .reg18(reg18));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
