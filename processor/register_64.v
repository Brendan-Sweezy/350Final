module register_64 (q, dLSB, dMSB, clk, writeLSB, writeMSB, resetMSB, resetLSB);

	input [31:0] dLSB, dMSB;
    input clk, writeMSB, writeLSB, resetMSB, resetLSB;

    output [63:0] q;
    
    register msb(.q(q[63:32]), .d(dMSB), .clk(clk), .write(writeMSB), .reset(resetMSB));
    register lsb(.q(q[31:0]), .d(dLSB), .clk(clk), .write(writeLSB), .reset(resetLSB));

endmodule
