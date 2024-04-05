/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB,                   // I: Data from port B of RegFile
	
	//OUTPUT
	out_pc,
	
	//VGA
    hSync, vSync,
    VGA_B, VGA_G, VGA_R
	 
	);

    //VGA Outputs
    output hSync; 		// H Sync Signal
	output vSync; 		// Veritcal Sync Signal
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G;  // Green Signal Bits
	output[3:0] VGA_B;  // Blue Signal Bits
	
	wire active;
	
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clock) begin
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
		.screenEnd(), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(), 				   // X Coordinate (from left)
		.y()); 			   // Y Coordinate (from top)	
	
	//Temp
	assign VGA_B = 4'b0000;
	assign VGA_G = 4'b1111;
	assign VGA_R = 4'b1111;

    //FOR TESTING
    output [31:0] out_pc; 
    assign out_pc = w_pc;

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
    
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    wire notclk;
    assign notclk = ~clock;

	/* YOUR CODE STARTS HERE */
	
    //Program Counter
    wire w_pc_add_overflow, f_do_jr;
    wire[4:0] f_opcode;
    wire[26:0] f_target;
    wire[31:0] w_pc, w_pc_next, f_pc_increment;
    

    register PC(.q(w_pc), .d(w_pc_next), .clk(notclk), .write(x_continue && ~d_stall), .reset(reset)); //Could have to make clock low
    cla_adder_32 PC_Add(.A(32'b0), .B(w_pc), .c0(1'b1), .S(f_pc_increment), .overflow(w_pc_add_overflow)); //Overflow shouldn't do anything
    assign address_imem = w_pc;

    instruction_decoder F_decoder(.instruction(q_imem), .opcode(f_opcode), .rd(), .rs(), .rt(), .shamt(), .ALUop(), .target(f_target), .shifted_immediate());
    
    f_control f_con(.pc_next(w_pc_next), .opcode(f_opcode), .pc_increment(f_pc_increment), .target(f_target), .pc_reg(d_dataB), .do_jr(f_do_jr), .branch_target(x_ALU_result), .do_branch(x_do_branch), .bex_target(x_shifted_target), .bex_jump(x_do_jump));

    // F/D
    wire [31:0] fd_ir, fd_pc;
    wire [4:0] fd_rs, fd_rt, fd_rd, fd_opcode;
    
    register FD_PC(.q(fd_pc), .d(x), .clk(notclk), .write(x_continue && ~d_stall), .reset(reset));
    register FD_IR(.q(fd_ir), .d(y), .clk(notclk), .write(x_continue && ~d_stall), .reset(reset));

    wire[31:0] x = f_do_jr || x_do_branch || x_do_jump ? 32'b0 : w_pc;
    wire[31:0] y =  f_do_jr || x_do_branch || x_do_jump ? 32'b0 : q_imem;

    instruction_decoder FD_decoder(.instruction(fd_ir), .opcode(fd_opcode), .rd(fd_rd), .rs(fd_rs), .rt(fd_rt), .shamt(), .ALUop(), .target(), .shifted_immediate());

    //Read Reg File
    wire [31:0] d_dataA, d_dataB;
    wire [4:0] d_readRegB, d_readRegA;
    wire d_stall;

    assign ctrl_readRegA = d_readRegA;
    assign ctrl_readRegB = d_readRegB;

    //ALWAYS STALLING COULD BE MORE EFFICIENT IF CHECK REG DEPENDENCIES
    d_control d_con(.readA(d_readRegA), .readB(d_readRegB), .dataA(d_dataA), .dataB(d_dataB), .do_jr(f_do_jr), .stall(d_stall), .opcode(fd_opcode), .rt(fd_rt), .rs(fd_rs), .rd(fd_rd), .pc(fd_pc), .dataAin(data_readRegA), .dataBin(data_readRegB), .x_rd(dx_rd), .x_res(x_overflow ? x_error_code : x_result), .x_writ(x_writ), .m_rd(xm_rd), .m_res(m_write_back), .m_writ(m_writ), .loading(x_loading), .overflow(x_overflow), .x_jal(x_jal), .m_jal(m_jal));

    // D/X
    wire [31:0] dx_ir, dx_pc, dx_A, dx_B, dx_shifted_immediate;
    wire [26:0] dx_target;
    wire [4:0] dx_shamt, dx_opcode, dx_ALUop, dx_rd;
    
    register DX_PC(.q(dx_pc), .d(d_stall || x_do_branch ? 32'b0 : fd_pc), .clk(notclk), .write(x_continue), .reset(reset));
    register DX_IR(.q(dx_ir), .d(d_stall || x_do_branch ? 32'b0 : fd_ir), .clk(notclk), .write(x_continue), .reset(reset));
    register DX_A(.q(dx_A), .d(d_stall || x_do_branch ? 32'b0 : d_dataA), .clk(notclk), .write(x_continue), .reset(reset));
    register DX_B(.q(dx_B), .d(d_stall || x_do_branch ? 32'b0 : d_dataB), .clk(notclk), .write(x_continue), .reset(reset));

    instruction_decoder DX_decoder(.instruction(dx_ir), .opcode(dx_opcode), .rd(dx_rd), .rs(), .rt(), .shamt(dx_shamt), .ALUop(dx_ALUop), .target(dx_target), .shifted_immediate(dx_shifted_immediate));

    //ALU
    wire [31:0] x_error_code, x_ALU_result, x_ALU_dataB, x_ALU_dataA, x_shifted_target, x_result, x_muldiv_result;
    wire [4:0] x_ALUop;
    wire x_jal, x_writ, x_ALU_not_eq, x_ALU_less, x_ALU_overflow, x_multdiv_overflow, x_do_branch, x_do_jump, x_muldiv_ready, x_continue, x_in_muldiv, x_overflow, x_loading;

    alu ALU(.data_operandA(x_ALU_dataA), .data_operandB(x_ALU_dataB), .ctrl_ALUopcode(x_ALUop), .ctrl_shiftamt(dx_shamt), .data_result(x_ALU_result), .isNotEqual(), .isLessThan(), .overflow(x_ALU_overflow));
    alu compareALU(.data_operandA(dx_B), .data_operandB(dx_A), .ctrl_ALUopcode(5'b00001), .ctrl_shiftamt(dx_shamt), .data_result(), .isNotEqual(x_ALU_not_eq), .isLessThan(x_ALU_less), .overflow());
    multdiv muldiv(.data_operandA(dx_A), .data_operandB(dx_B), .ctrl_MULT(~x_ALUop[0] && ~x_in_muldiv), .ctrl_DIV(x_ALUop[0] && ~x_in_muldiv), .clock(clock), .data_result(x_muldiv_result), .data_exception(x_multdiv_overflow), .data_resultRDY(x_muldiv_ready));
    dffe_ref inMulDiv(.q(x_in_muldiv), .d(~x_continue && ~x_in_muldiv), .clk(clock), .en(~x_in_muldiv || x_muldiv_ready), .clr(1'b0));

    x_control x_con(.x_res(x_result), .ALU_dataA(x_ALU_dataA), .ALU_dataB(x_ALU_dataB), .ALUopOut(x_ALUop), .do_branch(x_do_branch), .do_jump(x_do_jump), .continue(x_continue), .shifted_target(x_shifted_target), .overflow(x_overflow), .writing(x_writ), .loading(x_loading), .error_code(x_error_code), .opcode(dx_opcode), .ALUopIn(dx_ALUop), .data_B(dx_B), .shifted_immediate(dx_shifted_immediate), .is_less(x_ALU_less), .is_neq(x_ALU_not_eq), .data_A(dx_A), .pc(dx_pc), .target(dx_target), .muldiv_ready(x_muldiv_ready), .ALU_res(x_ALU_result), .muldiv_res(x_muldiv_result), .ALUov(x_ALU_overflow), .muldivov(x_multdiv_overflow), .jal(x_jal));
    
    // X/M
    wire [31:0] xm_ir, xm_B, xm_o;
    wire [4:0] xm_opcode, xm_rd;
    wire m_wren, xm_overflow;
    
    register XM_IR(.q(xm_ir), .d(dx_ir), .clk(notclk), .write(x_continue), .reset(reset));
    register XM_O(.q(xm_o), .d(x_result), .clk(notclk), .write(x_continue), .reset(reset));
    register XM_B(.q(xm_B), .d(dx_B), .clk(notclk), .write(x_continue), .reset(reset));
    dffe_ref XM_OV(.q(xm_overflow), .d(x_overflow), .clk(notclk), .en(x_continue), .clr(reset));

    instruction_decoder XM_decoder(.instruction(xm_ir), .opcode(xm_opcode), .rd(xm_rd), .rs(), .rt(), .shamt(), .ALUop(), .target(), .shifted_immediate());

    //Memory
    wire m_writ, m_jal;
    wire[31:0] m_data, m_write_back;
    
    assign address_dmem = xm_o;
    assign data = m_data;
    assign wren = m_wren;

    m_control m_con(.write_en(m_wren), .data(m_data), .writing(m_writ), .write_back(m_write_back), .jal(m_jal), .opcode(xm_opcode), .dataB(xm_B), .loading(w_loading), .loadData(w_writeData), .m_rd(xm_rd), .w_rd(mw_rd), .out(xm_o), .outdata(q_dmem));
    

    // M/W
    wire [31:0] mw_ir, mw_o, mw_d;
    wire [26:0] mw_target;
    wire [4:0] mw_rd, mw_opcode, mw_ALUop;
    wire mw_overflow;

    register MW_IR(.q(mw_ir), .d(xm_ir), .clk(notclk), .write(x_continue), .reset(reset));
    register MW_O(.q(mw_o), .d(xm_o), .clk(notclk), .write(x_continue), .reset(reset));
    register MW_D(.q(mw_d), .d(q_dmem), .clk(notclk), .write(x_continue), .reset(reset));
    dffe_ref MW_OV(.q(mw_overflow), .d(xm_overflow), .clk(notclk), .en(x_continue), .clr(reset));

    instruction_decoder MW_decoder(.instruction(mw_ir), .opcode(mw_opcode), .rd(mw_rd), .rs(), .rt(), .shamt(), .ALUop(mw_ALUop), .target(mw_target), .shifted_immediate());

    wire[31:0] w_writeData;
    wire[4:0] w_writeReg;
    wire w_writeEn, w_loading;

    assign ctrl_writeEnable = w_writeEn; 
    assign data_writeReg = w_writeData;
    assign ctrl_writeReg = w_writeReg;

    w_control w_con(.write_data(w_writeData), .write_ctrl(w_writeEn), .write_reg(w_writeReg), .loading(w_loading), .D(mw_d), .O(mw_o), .opcode(mw_opcode), .rd(mw_rd), .target(mw_target), .overflow(mw_overflow), .ALUop(mw_ALUop));

	/* END CODE */

endmodule
