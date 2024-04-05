module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	SW, BTNR,
	reg26, reg27, reg28
);

	input clock, ctrl_writeEnable, ctrl_reset, BTNR;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	input [15:0] SW;

	output [31:0] data_readRegA, data_readRegB, reg26, reg27, reg28;

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
        for(i = 1; i < 26; i = i + 1) begin: registers
            wire [31:0] w0;
			wire w1;
			and and_0(w1, write[i], ctrl_writeEnable);
			register register(.q(w0), .d(data_writeReg), .clk(clock), .write(w1), .reset(ctrl_reset));		
			tristate_32 triOne(.out(data_readRegA), .in(w0), .select(readA[i]));
			tristate_32 triTwo(.out(data_readRegB), .in(w0), .select(readB[i]));
        end
    endgenerate
    
    //Reg 26
    wire [31:0] w_26_0;
    wire w_26_1;
    wire[31:0] d_write_26;
    assign d_write_26[31:8] = 24'b0;
    assign d_write_26[7:0] = SW[7:0];
	and and_0_26(w_26_1, write[26], ctrl_writeEnable);
	register register26(.q(w_26_0), .d(d_write_26), .clk(clock), .write(1'b1), .reset(ctrl_reset));		
	tristate_32 triOne_26(.out(data_readRegA), .in(w_26_0), .select(readA[26]));
	tristate_32 triTwo_26(.out(data_readRegB), .in(w_26_0), .select(readB[26]));
	assign reg26 = w_26_0;
	
	//Reg 27
    wire [31:0] w_27_0;
    wire w_27_1;
    wire[31:0] d_write_27;
    assign d_write_27[31:8] = 24'b0;
    assign d_write_27[7:0] = SW[15:8];
	and and_0_27(w_27_1, write[27], ctrl_writeEnable);
	register register27(.q(w_27_0), .d(d_write_27), .clk(clock), .write(1'b1), .reset(ctrl_reset));		
	tristate_32 triOne_27(.out(data_readRegA), .in(w_27_0), .select(readA[27]));
	tristate_32 triTwo_27(.out(data_readRegB), .in(w_27_0), .select(readB[27]));
	assign reg27 = w_27_0;
	
	//Reg 28
    wire [31:0] w_28_0;
    wire w_28_1;
    wire[31:0] d_write_28;
    assign d_write_28[31:1] = 31'b0;
    assign d_write_28[0] = BTNR;
	and and_0_28(w_28_1, write[28], ctrl_writeEnable);
	register register28(.q(w_28_0), .d(d_write_28), .clk(clock), .write(1'b1), .reset(ctrl_reset));		
	tristate_32 triOne_28(.out(data_readRegA), .in(w_28_0), .select(readA[28]));
	tristate_32 triTwo_28(.out(data_readRegB), .in(w_28_0), .select(readB[28]));
	assign reg28 = w_28_0;
    
    
    genvar j;
    generate
        for(j = 29; j < 32; j = j + 1) begin: registers_special
            wire [31:0] w0;
			wire w1;
			and and_0(w1, write[j], ctrl_writeEnable);
			register register(.q(w0), .d(data_writeReg), .clk(clock), .write(w1), .reset(ctrl_reset));		
			tristate_32 triOne(.out(data_readRegA), .in(w0), .select(readA[j]));
			tristate_32 triTwo(.out(data_readRegB), .in(w0), .select(readB[j]));
        end
    endgenerate

endmodule
