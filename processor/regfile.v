module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	SW, BTNR,
	reg26, reg27, reg28, reg25, reg19, reg20, reg21, reg22, reg23, reg24, reg17, reg18
);

	input clock, ctrl_writeEnable, ctrl_reset, BTNR;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	input [15:0] SW;

	output [31:0] data_readRegA, data_readRegB, reg26, reg27, reg28, reg25, reg19, reg20, reg21, reg22, reg23, reg24, reg17, reg18;

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
        for(i = 1; i < 17; i = i + 1) begin: registers
            wire [31:0] w0;
			wire w1;
			and and_0(w1, write[i], ctrl_writeEnable);
			register register(.q(w0), .d(data_writeReg), .clk(clock), .write(w1), .reset(ctrl_reset));		
			tristate_32 triOne(.out(data_readRegA), .in(w0), .select(readA[i]));
			tristate_32 triTwo(.out(data_readRegB), .in(w0), .select(readB[i]));
        end
    endgenerate
    
    //Reg 17
    wire [31:0] w_17_0;
    wire w_17_1;
	and and_0_17(w_17_1, write[17], ctrl_writeEnable);
	register register17(.q(w_17_0), .d(data_writeReg), .clk(clock), .write(w_17_1), .reset(ctrl_reset));		
	tristate_32 triOne_17(.out(data_readRegA), .in(w_17_0), .select(readA[17]));
	tristate_32 triTwo_17(.out(data_readRegB), .in(w_17_0), .select(readB[17]));
	assign reg17 = w_17_0;
    
    //Reg 18
    wire [31:0] w_18_0;
    wire w_18_1;
	and and_0_18(w_18_1, write[18], ctrl_writeEnable);
	register register18(.q(w_18_0), .d(data_writeReg), .clk(clock), .write(w_18_1), .reset(ctrl_reset));		
	tristate_32 triOne_18(.out(data_readRegA), .in(w_18_0), .select(readA[18]));
	tristate_32 triTwo_18(.out(data_readRegB), .in(w_18_0), .select(readB[18]));
	assign reg18 = w_18_0;
    
    //Reg 19
    wire [31:0] w_19_0;
    wire w_19_1;
	and and_0_19(w_19_1, write[19], ctrl_writeEnable);
	register register19(.q(w_19_0), .d(data_writeReg), .clk(clock), .write(w_19_1), .reset(ctrl_reset));		
	tristate_32 triOne_19(.out(data_readRegA), .in(w_19_0), .select(readA[19]));
	tristate_32 triTwo_19(.out(data_readRegB), .in(w_19_0), .select(readB[19]));
	assign reg19 = w_19_0;
	
	//Reg 20
    wire [31:0] w_20_0;
    wire w_20_1;
	and and_0_20(w_20_1, write[20], ctrl_writeEnable);
	register register20(.q(w_20_0), .d(data_writeReg), .clk(clock), .write(w_20_1), .reset(ctrl_reset));		
	tristate_32 triOne_20(.out(data_readRegA), .in(w_20_0), .select(readA[20]));
	tristate_32 triTwo_20(.out(data_readRegB), .in(w_20_0), .select(readB[20]));
	assign reg20 = w_20_0;
	
	//Reg 21
    wire [31:0] w_21_0;
    wire w_21_1;
	and and_0_21(w_21_1, write[21], ctrl_writeEnable);
	register register21(.q(w_21_0), .d(data_writeReg), .clk(clock), .write(w_21_1), .reset(ctrl_reset));		
	tristate_32 triOne_21(.out(data_readRegA), .in(w_21_0), .select(readA[21]));
	tristate_32 triTwo_21(.out(data_readRegB), .in(w_21_0), .select(readB[21]));
	assign reg21 = w_21_0;
	
	//Reg 22
    wire [31:0] w_22_0;
    wire w_22_1;
	and and_0_22(w_22_1, write[22], ctrl_writeEnable);
	register register22(.q(w_22_0), .d(data_writeReg), .clk(clock), .write(w_22_1), .reset(ctrl_reset));		
	tristate_32 triOne_22(.out(data_readRegA), .in(w_22_0), .select(readA[22]));
	tristate_32 triTwo_22(.out(data_readRegB), .in(w_22_0), .select(readB[22]));
	assign reg22 = w_22_0;
    
    //Reg 23
    wire [31:0] w_23_0;
    wire w_23_1;
	and and_0_23(w_23_1, write[23], ctrl_writeEnable);
	register register23(.q(w_23_0), .d(data_writeReg), .clk(clock), .write(w_23_1), .reset(ctrl_reset));		
	tristate_32 triOne_23(.out(data_readRegA), .in(w_23_0), .select(readA[23]));
	tristate_32 triTwo_23(.out(data_readRegB), .in(w_23_0), .select(readB[23]));
	assign reg23 = w_23_0;
    
    //Reg 24
    wire [31:0] w_24_0;
    wire w_24_1;
	and and_0_24(w_24_1, write[24], ctrl_writeEnable);
	register register24(.q(w_24_0), .d(data_writeReg), .clk(clock), .write(w_24_1), .reset(ctrl_reset));		
	tristate_32 triOne_24(.out(data_readRegA), .in(w_24_0), .select(readA[24]));
	tristate_32 triTwo_24(.out(data_readRegB), .in(w_24_0), .select(readB[24]));
	assign reg24 = w_24_0;
    
    //Reg 25
    wire [31:0] w_25_0;
    wire w_25_1;
	and and_0_25(w_25_1, write[25], ctrl_writeEnable);
	register register25(.q(w_25_0), .d(data_writeReg), .clk(clock), .write(w_25_1), .reset(ctrl_reset));		
	tristate_32 triOne_25(.out(data_readRegA), .in(w_25_0), .select(readA[25]));
	tristate_32 triTwo_25(.out(data_readRegB), .in(w_25_0), .select(readB[25]));
	assign reg25 = w_25_0;
    
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
