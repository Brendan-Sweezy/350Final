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

module Wrapper (CLK100MHZ, BTNC, BTNR, LED, hSync, vSync, VGA_B, VGA_G, VGA_R, SW);
	input CLK100MHZ, BTNC, BTNR;
	input[15:0] SW;
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
		memAddr, memDataIn, memDataOut, pc, reg26, reg27, reg28, reg25;
		
	assign clock = CLK100MHZ;
	assign reset = BTNC;
    
    assign LED[15:0] = reg25[15:0];
    //assign LED[7:0] = SW[7:0];
    //assign LED[7:0] = reg26[7:0];
    //assign LED[14:8] = reg27[6:0];
    //assign LED[15] = reg28[0];
    //assign LED[0] = vSync;
    //assign LED[1] = hSync;
    
    //assign LED = pc[7:0];
    //assign LED = 8'b10101010;

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "checkersbasic";
	
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
		.out_pc(pc),
		.hSync(hSync), .vSync(vSync),
		.VGA_B(VGA_B), .VGA_G(VGA_G), .VGA_R(VGA_R)); 
	
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
		.reg26(reg26), .reg27(reg27), .reg28(reg28), .reg25(reg25));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
