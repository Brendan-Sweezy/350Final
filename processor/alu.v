module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] w0, w1, w2, w3, w4, w5, notB, w6;

    assign w5 = 0;
    //assign isLessThan = w0[31];

    cla_adder_32 adder(data_operandA, w6, ctrl_ALUopcode[0], w0, overflow);
    and_32 myAnd(data_operandA, data_operandB, w1);
    or_32 myOr(data_operandA, data_operandB, w2);
    sll left_shift(data_operandA, ctrl_shiftamt, w3);
    sra right_shift(data_operandA, ctrl_shiftamt, w4);
    or not0(isNotEqual, w0[0], w0[1], w0[2], w0[3], w0[4], w0[5], w0[6], w0[7], w0[8], w0[9], w0[10], w0[11], w0[12], w0[13], w0[14], w0[15], w0[16], w0[17], w0[18], w0[19], w0[20], w0[21], w0[22], w0[23], w0[24], w0[25], w0[26], w0[27], w0[28], w0[29], w0[30], w0[31]);
    mux_8 mux(data_result, ctrl_ALUopcode[2:0], w0, w0, w1, w2, w3, w4, w5, w5);
    negate_32 notBGate(data_operandB, notB);
    mux_2 selectB(w6, ctrl_ALUopcode[0], data_operandB, notB);

    mux_2_single selectLess(isLessThan, overflow, w0[31], ~w0[31]);

endmodule