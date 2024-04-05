module multdiv(
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

    //Div/Mul combine
    wire [31:0] div_final, mul_final;
    wire div_data_resultRDY, mult_data_exception, mult_data_resultRDY;

    dffe_ref do_mult(.q(w_do_mult), .d(ctrl_MULT), .clk(clock), .en(ctrl_DIV || ctrl_MULT), .clr(1'b0));
    mux_2 select_result(.out(data_result), .select(w_do_mult), .in0(div_final), .in1(mul_final));
    assign data_exception = (wd_zero && ~w_do_mult) || (mult_data_exception && w_do_mult);
    assign data_resultRDY = (w_do_mult && mult_data_resultRDY) || (~w_do_mult && div_data_resultRDY);
    
    //Divider

    wire is_start, wd_negateFinal, wd_start, wd_zero, wd_trash_overflow, wd_trash_overflow1, wd_trash_overflow2, wd_do_sub, wd_div_overflow;
    wire [31:0] wd_neg_dividend2, wd_res_op, wd_res_neg, wd_decided_op_2, wd_op_divider_neg, wd_op_divider, wd_lsb2, wd_edit_last_bit, wd_op_dividend, wd_dividend, wd_op_dividend_neg, wd_decided_op, wd_div_add_res, wd_div_neg, wd_addA, wd_msb, wd_lsb;
    wire [63:0] wd_start_input, wd_reg_input_temp, wd_reg_input, wd_rem_quo, wd_rem_quo_shifted, wd_add_success;
    wire [1:0] wd_proc_clock;
    
    //Registers
    register dividend(.q(wd_dividend), .d(wd_decided_op), .clk(clock), .write(ctrl_DIV), .reset(1'b0));
    register_64 rem_quo(.q(wd_rem_quo), .dLSB(wd_reg_input[31:0]), .dMSB(wd_reg_input[63:32]), .clk(clock), .writeLSB(1'b1), .writeMSB(1'b1), .resetMSB(ctrl_DIV), .resetLSB(1'b0));

    //Negate dividend input
    negate_32 opDividend(.A(data_operandB), .S(wd_op_dividend));
    cla_adder_32 adder_negate(.A(32'b0), .B(wd_op_dividend), .c0(1'b1), .S(wd_op_dividend_neg), .overflow(wd_trash_overflow));
    mux_2 select_dividend(.out(wd_decided_op), .select(data_operandB[31]), .in0(data_operandB), .in1(wd_op_dividend_neg));

    //Negate divider input
    negate_32 opDivider(.A(data_operandA), .S(wd_op_divider));
    cla_adder_32 adder_negate2(.A(32'b0), .B(wd_op_divider), .c0(1'b1), .S(wd_op_divider_neg), .overflow(wd_trash_overflow1));
    mux_2 select_divider(.out(wd_decided_op_2), .select(data_operandA[31]), .in0(data_operandA), .in1(wd_op_divider_neg));

    //Negate answer
    dffe_ref negateFinal(.q(wd_negateFinal), .d(data_operandA[31] ^ data_operandB[31]), .clk(clock), .en(ctrl_DIV), .clr(1'b0));
    negate_32 opResult(.A(wd_rem_quo[31:0]), .S(wd_res_neg));
    cla_adder_32 adder_neg_final(.A(32'b0), .B(wd_res_neg), .c0(1'b1), .S(wd_res_op), .overflow(wd_trash_overflow2));
    mux_2 select_div_res(.out(div_final), .select(wd_negateFinal), .in0(wd_rem_quo[31:0]), .in1(wd_res_op));


    //Negate dividend
    negate_32 opDividend_2(.A(wd_dividend), .S(wd_neg_dividend2));

    //ADDER
    cla_adder_32 adder_div(.A(wd_neg_dividend2), .B(wd_rem_quo_shifted[63:32]), .c0(1'b1), .S(wd_div_add_res), .overflow(wd_div_overflow));

    //Add Success
    assign wd_add_success[63:32] = wd_div_add_res;
    assign wd_add_success[31:1] = wd_rem_quo_shifted[31:1];
    assign wd_add_success[0] = 1'b1;

    //Assign register feedback
    assign wd_reg_input_temp = wd_div_add_res[31] ? wd_rem_quo_shifted : wd_add_success;
    assign wd_start_input[31:0] = wd_decided_op_2;
    assign wd_start_input[63:32] = 32'b0;
    assign wd_reg_input = (ctrl_DIV || is_start) ? wd_start_input : wd_reg_input_temp;
    assign is_start = ~w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && ~w_counter[0];
    
    //Shifter
    assign wd_rem_quo_shifted = wd_rem_quo << 1;

    //Define Exceptions
    assign wd_zero = ~data_operandB[0] && ~data_operandB[1] && ~data_operandB[2] && ~data_operandB[3] && ~data_operandB[4] && ~data_operandB[5] && ~data_operandB[6] && ~data_operandB[7] && ~data_operandB[8] && ~data_operandB[9] && ~data_operandB[10] && ~data_operandB[11] && ~data_operandB[12] && ~data_operandB[13] && ~data_operandB[14] && ~data_operandB[15] && ~data_operandB[16] && ~data_operandB[17] && ~data_operandB[18] && ~data_operandB[19] && ~data_operandB[20] && ~data_operandB[21] && ~data_operandB[22] && ~data_operandB[23] && ~data_operandB[24] && ~data_operandB[25] && ~data_operandB[26] && ~data_operandB[27] && ~data_operandB[28] && ~data_operandB[29] && ~data_operandB[30] && ~data_operandB[31];

    //Ready
    assign div_data_resultRDY = wd_zero || (~w_counter[6] && w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && w_counter[0]);
    
    
    //Multiplier

    wire[64:0] pm_unmodified, pm_add_mult, pm_sub_mult, pm_add_mult_shifted, pm_sub_mult_shifted, booth_res, w_input, feed_reg, shifted_booth;
    wire[31:0] pm_add_mult_msb, pm_sub_mult_msb, pm_add_mult_shifted_msb, w_multiplicand_negated_shifted, pm_sub_mult_shifted_msb;

    //Registers
    register multiplicand(.q(w_multiplicand), .d(data_operandA), .clk(clock), .write(ctrl_MULT), .reset(1'b0));
    register_64 prod_multiplier(.q(w_prod_multiplier), .dLSB(feed_reg[32:1]), .dMSB(feed_reg[64:33]), .clk(clock), .writeLSB(1'b1), .writeMSB(1'b1), .resetMSB(1'b0), .resetLSB(1'b0));
    dffe_ref extra(.q(w_extra_q), .d(feed_reg[0]), .clk(clock), .en(1'b1), .clr(ctrl_MULT));

    //Unmodified
    assign pm_unmodified[64:1] = w_prod_multiplier;
    assign pm_unmodified[0] = w_extra_q;

    //Add Mult
    assign pm_add_mult[32:0] = pm_unmodified[32:0];
    cla_adder_32 pm_add_mult_adder(.A(pm_unmodified[64:33]), .B(w_multiplicand), .c0(1'b0), .S(pm_add_mult_msb), .overflow());
    assign pm_add_mult[64:33] = pm_add_mult_msb;

    //Sub Mult
    negate_32 notMult(.A(w_multiplicand), .S(w_multiplicand_negated));
    assign pm_sub_mult[32:0] = pm_unmodified[32:0];
    cla_adder_32 pm_sub_mult_adder(.A(pm_unmodified[64:33]), .B(w_multiplicand_negated), .c0(1'b1), .S(pm_sub_mult_msb), .overflow());
    assign pm_sub_mult[64:33] = pm_sub_mult_msb;

    //Add Mult Shifted
    assign pm_add_mult_shifted[32:0] = pm_unmodified[32:0];
    cla_adder_32 pm_add_mult_adder_2(.A(pm_unmodified[64:33]), .B(w_multiplicand << 1), .c0(1'b0), .S(pm_add_mult_shifted_msb), .overflow());
    assign pm_add_mult_shifted[64:33] = pm_add_mult_shifted_msb;

    //Sub Mult
    negate_32 notMult2(.A(w_multiplicand << 1), .S(w_multiplicand_negated_shifted));
    assign pm_sub_mult_shifted[32:0] = pm_unmodified[32:0];
    cla_adder_32 pm_sub_mult_adder_2(.A(pm_unmodified[64:33]), .B(w_multiplicand_negated_shifted), .c0(1'b1), .S(pm_sub_mult_shifted_msb), .overflow());
    assign pm_sub_mult_shifted[64:33] = pm_sub_mult_shifted_msb;    

    //Select Result
    mux_8_65 res_select(.out(booth_res), .select(pm_unmodified[2:0]), .in0(pm_unmodified), .in1(pm_add_mult), .in2(pm_add_mult), .in3(pm_add_mult_shifted), .in4(pm_sub_mult_shifted), .in5(pm_sub_mult), .in6(pm_sub_mult), .in7(pm_unmodified));

    //Declare initial value
    assign w_input[0] = 1'b0;
    assign w_input[32:1] = data_operandB;
    assign w_input[64:33] = 32'b0;

    //Shifted Booth
    assign shifted_booth[64] = booth_res[64];
    assign shifted_booth[63] = booth_res[64];
    assign shifted_booth[62:0] = booth_res[64:2];
    
    //Assign reg input
    assign feed_reg = ctrl_DIV || (~w_counter[6] && ~w_counter[5] && ~w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && ~w_counter[0]) ? w_input : shifted_booth;

    //Counter
    counter_64 counter(.q(w_counter), .clk(clock), .clr(ctrl_MULT || ctrl_DIV));

    //Overflow, match signs
    dffe_ref expectedSign(.q(w_expected_sign), .d((data_operandA[31] ^ data_operandB[31]) && ~w_in_zero), .clk(clock), .en(ctrl_MULT), .clr(1'b0));
    assign w_wrong_sign = mul_final[31] ^ w_expected_sign;
    assign w_in_zero = (~data_operandA[0] && ~data_operandA[1] && ~data_operandA[2] && ~data_operandA[3] && ~data_operandA[4] && ~data_operandA[5] && ~data_operandA[6] && ~data_operandA[7] && ~data_operandA[8] && ~data_operandA[9] && ~data_operandA[10] && ~data_operandA[11] && ~data_operandA[12] && ~data_operandA[13] && ~data_operandA[14] && ~data_operandA[15] && ~data_operandA[16] && ~data_operandA[17] && ~data_operandA[18] && ~data_operandA[19] && ~data_operandA[20] && ~data_operandA[21] && ~data_operandA[22] && ~data_operandA[23] && ~data_operandA[24] && ~data_operandA[25] && ~data_operandA[26] && ~data_operandA[27] && ~data_operandA[28] && ~data_operandA[29] && ~data_operandA[30] && ~data_operandA[31]) || (~data_operandB[0] && ~data_operandB[1] && ~data_operandB[2] && ~data_operandB[3] && ~data_operandB[4] && ~data_operandB[5] && ~data_operandB[6] && ~data_operandB[7] && ~data_operandB[8] && ~data_operandB[9] && ~data_operandB[10] && ~data_operandB[11] && ~data_operandB[12] && ~data_operandB[13] && ~data_operandB[14] && ~data_operandB[15] && ~data_operandB[16] && ~data_operandB[17] && ~data_operandB[18] && ~data_operandB[19] && ~data_operandB[20] && ~data_operandB[21] && ~data_operandB[22] && ~data_operandB[23] && ~data_operandB[24] && ~data_operandB[25] && ~data_operandB[26] && ~data_operandB[27] && ~data_operandB[28] && ~data_operandB[29] && ~data_operandB[30] && ~data_operandB[31]);

    //assign res
    assign mul_final = w_prod_multiplier[31:0];

    //Overflow
    assign mult_data_exception = ~w_overflow_3 || w_wrong_sign;
    or  orOverflow(w_overflow_3, w_overflow_1, w_overflow_2);

    and andOverflow1(w_overflow_1, w_prod_multiplier[31], w_prod_multiplier[32], w_prod_multiplier[33], w_prod_multiplier[34], w_prod_multiplier[35], w_prod_multiplier[36], w_prod_multiplier[37], w_prod_multiplier[38], w_prod_multiplier[39], w_prod_multiplier[40], w_prod_multiplier[41], w_prod_multiplier[42], w_prod_multiplier[43], w_prod_multiplier[44], w_prod_multiplier[45], w_prod_multiplier[46], w_prod_multiplier[47], w_prod_multiplier[48], w_prod_multiplier[49], w_prod_multiplier[50], w_prod_multiplier[51], w_prod_multiplier[52], w_prod_multiplier[53], w_prod_multiplier[54], w_prod_multiplier[55], w_prod_multiplier[56], w_prod_multiplier[57], w_prod_multiplier[58], w_prod_multiplier[59], w_prod_multiplier[60], w_prod_multiplier[61], w_prod_multiplier[62], w_prod_multiplier[63]);
    and andOverflow2(w_overflow_2, ~w_prod_multiplier[31], ~w_prod_multiplier[32], ~w_prod_multiplier[33], ~w_prod_multiplier[34], ~w_prod_multiplier[35], ~w_prod_multiplier[36], ~w_prod_multiplier[37], ~w_prod_multiplier[38], ~w_prod_multiplier[39], ~w_prod_multiplier[40], ~w_prod_multiplier[41], ~w_prod_multiplier[42], ~w_prod_multiplier[43], ~w_prod_multiplier[44], ~w_prod_multiplier[45], ~w_prod_multiplier[46], ~w_prod_multiplier[47], ~w_prod_multiplier[48], ~w_prod_multiplier[49], ~w_prod_multiplier[50], ~w_prod_multiplier[51], ~w_prod_multiplier[52], ~w_prod_multiplier[53], ~w_prod_multiplier[54], ~w_prod_multiplier[55], ~w_prod_multiplier[56], ~w_prod_multiplier[57], ~w_prod_multiplier[58], ~w_prod_multiplier[59], ~w_prod_multiplier[60], ~w_prod_multiplier[61], ~w_prod_multiplier[62], ~w_prod_multiplier[63]);

    //Mult Ready
    assign mult_data_resultRDY = (~w_counter[5] && w_counter[4] && ~w_counter[3] && ~w_counter[2] && ~w_counter[1] && w_counter[0]);


    //000 - pm_unmodified
    //001 - pm_add_mult
    //010 - pm_add_mult
    //011 - pm_add_mult_shifted
    //100 - pm_sub_mult_shifted
    //101 - pm_sub_mult
    //110 - pm_sub_mult
    //111 - pm_unmodified

endmodule