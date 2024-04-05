module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] readA, readB, write;

	//Decoders
	assign readA = 32'b1 << ctrl_readRegA;
	assign readB = 32'b1 << ctrl_readRegB;
	assign write = 32'b1 << ctrl_writeReg;

	//Register 0
	wire [31:0] w_zero_0;
	wire w_zero_1;
	and and_0(w_zero_1, write[0], ctrl_writeEnable);
	register register(.q(w_zero_0), .d(32'b0), .clk(clock), .write(w_zero_1), .reset(ctrl_reset));		
	tristate_32 triOne(.out(data_readRegA), .in(w_zero_0), .select(readA[0]));
	tristate_32 triTwo(.out(data_readRegB), .in(w_zero_0), .select(readB[0]));
	
	//Registers 1-31
	genvar i;
    generate
        for(i = 1; i < 32; i = i + 1) begin: registers
            wire [31:0] w0;
			wire w1;
			and and_0(w1, write[i], ctrl_writeEnable);
			register register(.q(w0), .d(data_writeReg), .clk(clock), .write(w1), .reset(ctrl_reset));		
			tristate_32 triOne(.out(data_readRegA), .in(w0), .select(readA[i]));
			tristate_32 triTwo(.out(data_readRegB), .in(w0), .select(readB[i]));
        end
    endgenerate

endmodule
