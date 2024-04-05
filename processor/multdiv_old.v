module multdiv_old(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] w_multiplicand, w_multiplicand_shifted, w_add_S, w_negate, w_multiplicand_negated, w_prod_multiplier_write_msb, w_prod_multiplier_write_lsb;
    wire [6:0] w_counter;
    wire [63:0] w_prod_multiplier, w_prod_multiplier_shifted;
    wire w_in_zero, w_wrong_sign, w_expected_sign, w_do_mult, w_extra_d, w_extra_q, w_add_overflow, w_1_shift_enable, w_2_shift_enable, w_add_sub, w_add_do, w_control_sub, w_control_shift_1, w_control_shift_2, w_control_do, w_add_do1, w_add_do2, w_overflow_1, w_overflow_2, w_overflow_3;

    wire wd_negateFinal, wd_start, wd_zero, wd_trash_overflow, wd_trash_overflow1, wd_trash_overflow2, wd_do_sub, wd_div_overflow;
    wire [31:0] wd_res_op, wd_res_neg, wd_decided_op_2, wd_op_divider_neg, wd_op_divider, wd_lsb2, wd_edit_last_bit, wd_op_dividend, wd_dividend, wd_op_dividend_neg, wd_decided_op, wd_div_add_res, wd_div_neg, wd_addA, wd_msb, wd_lsb;
    wire [63:0] wd_rem_quo, wd_rem_quo_shifted;
    wire [1:0] wd_proc_clock;

    wire [31:0] div_final, mul_final;
    wire div_data_resultRDY, mult_data_exception, mult_data_resultRDY;

    //Div/Mul combine

    dffe_ref do_mult(.q(w_do_mult), .d(ctrl_MULT), .clk(clock), .en(ctrl_DIV || ctrl_MULT), .clr(1'b0));
    mux_2 select_result(.out(data_result), .select(w_do_mult), .in0(div_final), .in1(mul_final));
    assign data_exception = (wd_zero && ~w_do_mult) || (mult_data_exception && w_do_mult);
    assign data_resultRDY = (w_do_mult && mult_data_resultRDY) || (~w_do_mult && div_data_resultRDY);
    
    //FIX MY MULTIPLIER OVERFLOW
    //Divider

    //0 add (except first), 1 shift, 2 subtract

    //Registers
    register dividend(.q(wd_dividend), .d(wd_decided_op), .clk(clock), .write(ctrl_DIV), .reset(1'b0));
    register_64 rem_quo(.q(wd_rem_quo), .dLSB(wd_lsb), .dMSB(wd_msb), .clk(clock), .writeLSB(ctrl_DIV || (~wd_proc_clock[1] && wd_proc_clock[0]) || (~wd_proc_clock[1] && ~wd_proc_clock[0])), .writeMSB((~wd_proc_clock[0] && wd_proc_clock[1]) || (~wd_proc_clock[0] && ~wd_proc_clock[1] && wd_rem_quo[63]) || (wd_proc_clock[0] && ~wd_proc_clock[1])), .resetMSB(ctrl_DIV), .resetLSB(1'b0));

    //Add/Sub
    cla_adder_32 adder_div(.A(wd_addA), .B(wd_rem_quo[63:32]), .c0(wd_do_sub), .S(wd_div_add_res), .overflow(wd_div_overflow));
    negate_32 negate_dividend(.A(wd_dividend), .S(wd_div_neg));
    mux_2 selectAddA(.out(wd_addA), .select(wd_do_sub), .in0(wd_dividend), .in1(wd_div_neg));

    //Negate dividend
    negate_32 opDividend(.A(data_operandB), .S(wd_op_dividend));
    cla_adder_32 adder_negate(.A(32'b0), .B(wd_op_dividend), .c0(1'b1), .S(wd_op_dividend_neg), .overflow(wd_trash_overflow));
    mux_2 select_dividend(.out(wd_decided_op), .select(data_operandB[31]), .in0(data_operandB), .in1(wd_op_dividend_neg));

    //Negate divider
    negate_32 opDivider(.A(data_operandA), .S(wd_op_divider));
    cla_adder_32 adder_negate2(.A(32'b0), .B(wd_op_divider), .c0(1'b1), .S(wd_op_divider_neg), .overflow(wd_trash_overflow1));
    mux_2 select_divider(.out(wd_decided_op_2), .select(data_operandA[31]), .in0(data_operandA), .in1(wd_op_divider_neg));

    //Negate answer
    dffe_ref negateFinal(.q(wd_negateFinal), .d(data_operandA[31] ^ data_operandB[31]), .clk(clock), .en(ctrl_DIV), .clr(1'b0));
    negate_32 opResult(.A(wd_rem_quo[31:0]), .S(wd_res_neg));
    cla_adder_32 adder_neg_final(.A(32'b0), .B(wd_res_neg), .c0(1'b1), .S(wd_res_op), .overflow(wd_trash_overflow2));
    mux_2 select_div_res(.out(div_final), .select(wd_negateFinal), .in0(wd_rem_quo[31:0]), .in1(wd_res_op));


    //Shifting/updating lsb
    assign wd_rem_quo_shifted = wd_rem_quo << 1;
    assign wd_edit_last_bit[31:1] = wd_rem_quo[31:1];
    assign wd_edit_last_bit[0] = ~wd_rem_quo[63]; 

    //Select input for reg
    mux_2 lsb_Div(.out(wd_lsb), .select(wd_start), .in0(wd_lsb2), .in1(wd_decided_op_2));
    mux_2 lsb_Div2(.out(wd_lsb2), .select(wd_proc_clock[0]), .in0(wd_edit_last_bit), .in1(wd_rem_quo_shifted[31:0]));
    mux_2 msb_Div(.out(wd_msb), .select(~wd_proc_clock[0]), .in0(wd_rem_quo_shifted[63:32]), .in1(wd_div_add_res));

    //procedure clock
    counter_4 procClock(.q(wd_proc_clock), .clk(clock), .clr((wd_proc_clock[0] && wd_proc_clock[1]) || ctrl_DIV));

    //Assign start
    assign wd_start = ~w_counter[6] && ~w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && ~w_counter[0];

    //define wd_do_sub
    assign wd_do_sub = ~wd_proc_clock[0] && wd_proc_clock[1];

    //assign div_final = wd_rem_quo[31:0];

    //Define data_exception
    assign wd_zero = ~data_operandB[0] && ~data_operandB[1] && ~data_operandB[2] && ~data_operandB[3] && ~data_operandB[4] && ~data_operandB[5] && ~data_operandB[6] && ~data_operandB[7] && ~data_operandB[8] && ~data_operandB[9] && ~data_operandB[10] && ~data_operandB[11] && ~data_operandB[12] && ~data_operandB[13] && ~data_operandB[14] && ~data_operandB[15] && ~data_operandB[16] && ~data_operandB[17] && ~data_operandB[18] && ~data_operandB[19] && ~data_operandB[20] && ~data_operandB[21] && ~data_operandB[22] && ~data_operandB[23] && ~data_operandB[24] && ~data_operandB[25] && ~data_operandB[26] && ~data_operandB[27] && ~data_operandB[28] && ~data_operandB[29] && ~data_operandB[30] && ~data_operandB[31];
    //assign data_exception = wd_zero;
    
    //Define data_rdy
    assign div_data_resultRDY = wd_zero || (w_counter[6] && w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && w_counter[0]);
    
    
    //Multiplier

    //Count[0] = 1, add, count[0] = 0, shift

    //Registers
    register multiplicand(.q(w_multiplicand), .d(data_operandA), .clk(clock), .write(ctrl_MULT), .reset(1'b0));
    register_64 prod_multiplier(.q(w_prod_multiplier), .dLSB(w_prod_multiplier_write_lsb), .dMSB(w_prod_multiplier_write_msb), .clk(clock), .writeLSB(ctrl_MULT || w_2_shift_enable), .writeMSB(w_add_do || w_2_shift_enable), .resetMSB(ctrl_MULT), .resetLSB(1'b0));
    dffe_ref extra(.q(w_extra_q), .d(w_extra_d), .clk(clock), .en(w_2_shift_enable), .clr(ctrl_MULT));

    //Adder
    cla_adder_32 adder(.A(w_prod_multiplier[63:32]), .B(w_negate), .c0(w_add_sub), .S(w_add_S), .overflow(w_add_overflow));

    //Shifters
    shift32_1 shift1(.S(w_multiplicand_shifted), .A(w_multiplicand), .en(w_1_shift_enable));
    shift64_2 shift2(.q(w_prod_multiplier_shifted), .d(w_prod_multiplier), .extra(w_extra_d));

    //Counter
    counter_64 counter(.q(w_counter), .clk(clock), .clr(ctrl_MULT || ctrl_DIV));

    //Mux Logic
    mux_2 negateSelect(.out(w_negate), .select(w_add_sub), .in0(w_multiplicand_shifted), .in1(w_multiplicand_negated));
    negate_32 negate(.A(w_multiplicand_shifted), .S(w_multiplicand_negated));
    mux_2 regwriteselect_1(.out(w_prod_multiplier_write_msb), .select(w_2_shift_enable), .in0(w_add_S), .in1(w_prod_multiplier_shifted[63:32]));
    mux_2 regwriteselect_2(.out(w_prod_multiplier_write_lsb), .select(~(~w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && ~w_counter[0])), .in0(data_operandB), .in1(w_prod_multiplier_shifted[31:0]));

    //Overflow, match signs
    dffe_ref expectedSign(.q(w_expected_sign), .d((data_operandA[31] ^ data_operandB[31]) && ~w_in_zero), .clk(clock), .en(ctrl_MULT), .clr(1'b0));
    assign w_wrong_sign = mul_final[31] ^ w_expected_sign;
    assign w_in_zero = (~data_operandA[0] && ~data_operandA[1] && ~data_operandA[2] && ~data_operandA[3] && ~data_operandA[4] && ~data_operandA[5] && ~data_operandA[6] && ~data_operandA[7] && ~data_operandA[8] && ~data_operandA[9] && ~data_operandA[10] && ~data_operandA[11] && ~data_operandA[12] && ~data_operandA[13] && ~data_operandA[14] && ~data_operandA[15] && ~data_operandA[16] && ~data_operandA[17] && ~data_operandA[18] && ~data_operandA[19] && ~data_operandA[20] && ~data_operandA[21] && ~data_operandA[22] && ~data_operandA[23] && ~data_operandA[24] && ~data_operandA[25] && ~data_operandA[26] && ~data_operandA[27] && ~data_operandA[28] && ~data_operandA[29] && ~data_operandA[30] && ~data_operandA[31]) || (~data_operandB[0] && ~data_operandB[1] && ~data_operandB[2] && ~data_operandB[3] && ~data_operandB[4] && ~data_operandB[5] && ~data_operandB[6] && ~data_operandB[7] && ~data_operandB[8] && ~data_operandB[9] && ~data_operandB[10] && ~data_operandB[11] && ~data_operandB[12] && ~data_operandB[13] && ~data_operandB[14] && ~data_operandB[15] && ~data_operandB[16] && ~data_operandB[17] && ~data_operandB[18] && ~data_operandB[19] && ~data_operandB[20] && ~data_operandB[21] && ~data_operandB[22] && ~data_operandB[23] && ~data_operandB[24] && ~data_operandB[25] && ~data_operandB[26] && ~data_operandB[27] && ~data_operandB[28] && ~data_operandB[29] && ~data_operandB[30] && ~data_operandB[31]);

    //Control
    //Define w_2_shift_enable

    and and_2_shift_enable(w_2_shift_enable, ~(~w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && ~w_counter[0]), ~w_counter[0]);

    //Define w_add_sub

    or or_add_sub(w_control_sub, ~w_prod_multiplier[0], ~w_extra_q);
    and and_add_sub(w_add_sub, w_control_sub, w_prod_multiplier[1]);

    //Define w_1_shift_enable

    and and_1_shift_enable_1(w_control_shift_1, w_prod_multiplier[1], ~w_prod_multiplier[0], ~w_extra_q);
    and and_1_shift_enable_2(w_control_shift_2, ~w_prod_multiplier[1], w_prod_multiplier[0], w_extra_q);
    or or_1_shift_enable(w_1_shift_enable, w_control_shift_1, w_control_shift_2);

    //Define w_add_do

    and and_add_do(w_add_do, w_counter[0], ~w_control_do);

    and and_add_do1(w_add_do1, w_prod_multiplier[1], w_prod_multiplier[0], w_extra_q);
    and and_add_do2(w_add_do2, ~w_prod_multiplier[1], ~w_prod_multiplier[0], ~w_extra_q);

    or or_add_do(w_control_do, w_add_do1, w_add_do2);

    //Assign data_result
    //TODO make this work between mult/divide

    assign mul_final = w_prod_multiplier[31:0];
    
    //Assign data_exception
    //TODO actually implement this lol

    //nand nandException = 
    
    //assign data_exception = 1'b0;
    //assign mult_data_exception = ~w_overflow_3 || w_add_overflow;
    assign mult_data_exception = ~w_overflow_3 || w_wrong_sign;
    or  orOverflow(w_overflow_3, w_overflow_1, w_overflow_2);
    //assign w_overflow_1 = ~(w_prod_multiplier[63] && w_prod_multiplier[62] && w_prod_multiplier[61] && w_prod_multiplier[60] && w_prod_multiplier[59] && w_prod_multiplier[58] && w_prod_multiplier[57] && w_prod_multiplier[56] && w_prod_multiplier[55] && w_prod_multiplier[54] && w_prod_multiplier[53] && w_prod_multiplier[52] && w_prod_multiplier[51] && w_prod_multiplier[50] && w_prod_multiplier[49] && w_prod_multiplier[48] && w_prod_multiplier[47] && w_prod_multiplier[46] && w_prod_multiplier[45] && w_prod_multiplier[44] && w_prod_multiplier[43] && w_prod_multiplier[42] && w_prod_multiplier[41] && w_prod_multiplier[40] && w_prod_multiplier[39] && w_prod_multiplier[38] && w_prod_multiplier[37] && w_prod_multiplier[36] && w_prod_multiplier[35] && w_prod_multiplier[34] && w_prod_multiplier[33] && w_prod_multiplier[32]);
    //assign w_overflow_2 = ~(~w_prod_multiplier[63] && ~w_prod_multiplier[62] && ~w_prod_multiplier[61] && ~w_prod_multiplier[60] && ~w_prod_multiplier[59] && ~w_prod_multiplier[58] && ~w_prod_multiplier[57] && ~w_prod_multiplier[56] && ~w_prod_multiplier[55] && ~w_prod_multiplier[54] && ~w_prod_multiplier[53] && ~w_prod_multiplier[52] && ~w_prod_multiplier[51] && ~w_prod_multiplier[50] && ~w_prod_multiplier[49] && ~w_prod_multiplier[48] && ~w_prod_multiplier[47] && ~w_prod_multiplier[46] && ~w_prod_multiplier[45] && ~w_prod_multiplier[44] && ~w_prod_multiplier[43] && ~w_prod_multiplier[42] && ~w_prod_multiplier[41] && ~w_prod_multiplier[40] && ~w_prod_multiplier[39] && ~w_prod_multiplier[38] && ~w_prod_multiplier[37] && ~w_prod_multiplier[36] && ~w_prod_multiplier[35] && ~w_prod_multiplier[34] && ~w_prod_multiplier[33] && ~w_prod_multiplier[32]);

    and andOverflow1(w_overflow_1, w_prod_multiplier[31], w_prod_multiplier[32], w_prod_multiplier[33], w_prod_multiplier[34], w_prod_multiplier[35], w_prod_multiplier[36], w_prod_multiplier[37], w_prod_multiplier[38], w_prod_multiplier[39], w_prod_multiplier[40], w_prod_multiplier[41], w_prod_multiplier[42], w_prod_multiplier[43], w_prod_multiplier[44], w_prod_multiplier[45], w_prod_multiplier[46], w_prod_multiplier[47], w_prod_multiplier[48], w_prod_multiplier[49], w_prod_multiplier[50], w_prod_multiplier[51], w_prod_multiplier[52], w_prod_multiplier[53], w_prod_multiplier[54], w_prod_multiplier[55], w_prod_multiplier[56], w_prod_multiplier[57], w_prod_multiplier[58], w_prod_multiplier[59], w_prod_multiplier[60], w_prod_multiplier[61], w_prod_multiplier[62], w_prod_multiplier[63]);
    and andOverflow2(w_overflow_2, ~w_prod_multiplier[31], ~w_prod_multiplier[32], ~w_prod_multiplier[33], ~w_prod_multiplier[34], ~w_prod_multiplier[35], ~w_prod_multiplier[36], ~w_prod_multiplier[37], ~w_prod_multiplier[38], ~w_prod_multiplier[39], ~w_prod_multiplier[40], ~w_prod_multiplier[41], ~w_prod_multiplier[42], ~w_prod_multiplier[43], ~w_prod_multiplier[44], ~w_prod_multiplier[45], ~w_prod_multiplier[46], ~w_prod_multiplier[47], ~w_prod_multiplier[48], ~w_prod_multiplier[49], ~w_prod_multiplier[50], ~w_prod_multiplier[51], ~w_prod_multiplier[52], ~w_prod_multiplier[53], ~w_prod_multiplier[54], ~w_prod_multiplier[55], ~w_prod_multiplier[56], ~w_prod_multiplier[57], ~w_prod_multiplier[58], ~w_prod_multiplier[59], ~w_prod_multiplier[60], ~w_prod_multiplier[61], ~w_prod_multiplier[62], ~w_prod_multiplier[63]);

    //Assign data_resultRDY
    //TODO implement logic for if a mult op is happening

    assign mult_data_resultRDY = (w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && w_counter[0]);

    //Feed shift back in done allegedly

endmodule