module sll(A, shiftamt, result);
        
    input [31:0] A;
    input [4:0] shiftamt;

    output [31:0] result;

    wire [31:0] w0, w1, w2, w3;
    wire zero = 0;

    //Shift 1 bit
    mux_2_single mux_0_0(w0[0], shiftamt[0], A[0], zero);
    mux_2_single mux_0_1(w0[1], shiftamt[0], A[1], A[0]);
    mux_2_single mux_0_2(w0[2], shiftamt[0], A[2], A[1]);
    mux_2_single mux_0_3(w0[3], shiftamt[0], A[3], A[2]);
    mux_2_single mux_0_4(w0[4], shiftamt[0], A[4], A[3]);
    mux_2_single mux_0_5(w0[5], shiftamt[0], A[5], A[4]);
    mux_2_single mux_0_6(w0[6], shiftamt[0], A[6], A[5]);
    mux_2_single mux_0_7(w0[7], shiftamt[0], A[7], A[6]);
    mux_2_single mux_0_8(w0[8], shiftamt[0], A[8], A[7]);
    mux_2_single mux_0_9(w0[9], shiftamt[0], A[9], A[8]);
    mux_2_single mux_0_10(w0[10], shiftamt[0], A[10], A[9]);
    mux_2_single mux_0_11(w0[11], shiftamt[0], A[11], A[10]);
    mux_2_single mux_0_12(w0[12], shiftamt[0], A[12], A[11]);
    mux_2_single mux_0_13(w0[13], shiftamt[0], A[13], A[12]);
    mux_2_single mux_0_14(w0[14], shiftamt[0], A[14], A[13]);
    mux_2_single mux_0_15(w0[15], shiftamt[0], A[15], A[14]);
    mux_2_single mux_0_16(w0[16], shiftamt[0], A[16], A[15]);
    mux_2_single mux_0_17(w0[17], shiftamt[0], A[17], A[16]);
    mux_2_single mux_0_18(w0[18], shiftamt[0], A[18], A[17]);
    mux_2_single mux_0_19(w0[19], shiftamt[0], A[19], A[18]);
    mux_2_single mux_0_20(w0[20], shiftamt[0], A[20], A[19]);
    mux_2_single mux_0_21(w0[21], shiftamt[0], A[21], A[20]);
    mux_2_single mux_0_22(w0[22], shiftamt[0], A[22], A[21]);
    mux_2_single mux_0_23(w0[23], shiftamt[0], A[23], A[22]);
    mux_2_single mux_0_24(w0[24], shiftamt[0], A[24], A[23]);
    mux_2_single mux_0_25(w0[25], shiftamt[0], A[25], A[24]);
    mux_2_single mux_0_26(w0[26], shiftamt[0], A[26], A[25]);
    mux_2_single mux_0_27(w0[27], shiftamt[0], A[27], A[26]);
    mux_2_single mux_0_28(w0[28], shiftamt[0], A[28], A[27]);
    mux_2_single mux_0_29(w0[29], shiftamt[0], A[29], A[28]);
    mux_2_single mux_0_30(w0[30], shiftamt[0], A[30], A[29]);
    mux_2_single mux_0_31(w0[31], shiftamt[0], A[31], A[30]);

    //Shift 2 bits
    mux_2_single mux_1_0(w1[0], shiftamt[1], w0[0], zero);
    mux_2_single mux_1_1(w1[1], shiftamt[1], w0[1], zero);
    mux_2_single mux_1_2(w1[2], shiftamt[1], w0[2], w0[0]);
    mux_2_single mux_1_3(w1[3], shiftamt[1], w0[3], w0[1]);
    mux_2_single mux_1_4(w1[4], shiftamt[1], w0[4], w0[2]);
    mux_2_single mux_1_5(w1[5], shiftamt[1], w0[5], w0[3]);
    mux_2_single mux_1_6(w1[6], shiftamt[1], w0[6], w0[4]);
    mux_2_single mux_1_7(w1[7], shiftamt[1], w0[7], w0[5]);
    mux_2_single mux_1_8(w1[8], shiftamt[1], w0[8], w0[6]);
    mux_2_single mux_1_9(w1[9], shiftamt[1], w0[9], w0[7]);
    mux_2_single mux_1_10(w1[10], shiftamt[1], w0[10], w0[8]);
    mux_2_single mux_1_11(w1[11], shiftamt[1], w0[11], w0[9]);
    mux_2_single mux_1_12(w1[12], shiftamt[1], w0[12], w0[10]);
    mux_2_single mux_1_13(w1[13], shiftamt[1], w0[13], w0[11]);
    mux_2_single mux_1_14(w1[14], shiftamt[1], w0[14], w0[12]);
    mux_2_single mux_1_15(w1[15], shiftamt[1], w0[15], w0[13]);
    mux_2_single mux_1_16(w1[16], shiftamt[1], w0[16], w0[14]);
    mux_2_single mux_1_17(w1[17], shiftamt[1], w0[17], w0[15]);
    mux_2_single mux_1_18(w1[18], shiftamt[1], w0[18], w0[16]);
    mux_2_single mux_1_19(w1[19], shiftamt[1], w0[19], w0[17]);
    mux_2_single mux_1_20(w1[20], shiftamt[1], w0[20], w0[18]);
    mux_2_single mux_1_21(w1[21], shiftamt[1], w0[21], w0[19]);
    mux_2_single mux_1_22(w1[22], shiftamt[1], w0[22], w0[20]);
    mux_2_single mux_1_23(w1[23], shiftamt[1], w0[23], w0[21]);
    mux_2_single mux_1_24(w1[24], shiftamt[1], w0[24], w0[22]);
    mux_2_single mux_1_25(w1[25], shiftamt[1], w0[25], w0[23]);
    mux_2_single mux_1_26(w1[26], shiftamt[1], w0[26], w0[24]);
    mux_2_single mux_1_27(w1[27], shiftamt[1], w0[27], w0[25]);
    mux_2_single mux_1_28(w1[28], shiftamt[1], w0[28], w0[26]);
    mux_2_single mux_1_29(w1[29], shiftamt[1], w0[29], w0[27]);
    mux_2_single mux_1_30(w1[30], shiftamt[1], w0[30], w0[28]);
    mux_2_single mux_1_31(w1[31], shiftamt[1], w0[31], w0[29]);

    //Shift 4 bits
    mux_2_single mux_2_0(w2[0], shiftamt[2], w1[0], zero);
    mux_2_single mux_2_1(w2[1], shiftamt[2], w1[1], zero);
    mux_2_single mux_2_2(w2[2], shiftamt[2], w1[2], zero);
    mux_2_single mux_2_3(w2[3], shiftamt[2], w1[3], zero);
    mux_2_single mux_2_4(w2[4], shiftamt[2], w1[4], w1[0]);
    mux_2_single mux_2_5(w2[5], shiftamt[2], w1[5], w1[1]);
    mux_2_single mux_2_6(w2[6], shiftamt[2], w1[6], w1[2]);
    mux_2_single mux_2_7(w2[7], shiftamt[2], w1[7], w1[3]);
    mux_2_single mux_2_8(w2[8], shiftamt[2], w1[8], w1[4]);
    mux_2_single mux_2_9(w2[9], shiftamt[2], w1[9], w1[5]);
    mux_2_single mux_2_10(w2[10], shiftamt[2], w1[10], w1[6]);
    mux_2_single mux_2_11(w2[11], shiftamt[2], w1[11], w1[7]);
    mux_2_single mux_2_12(w2[12], shiftamt[2], w1[12], w1[8]);
    mux_2_single mux_2_13(w2[13], shiftamt[2], w1[13], w1[9]);
    mux_2_single mux_2_14(w2[14], shiftamt[2], w1[14], w1[10]);
    mux_2_single mux_2_15(w2[15], shiftamt[2], w1[15], w1[11]);
    mux_2_single mux_2_16(w2[16], shiftamt[2], w1[16], w1[12]);
    mux_2_single mux_2_17(w2[17], shiftamt[2], w1[17], w1[13]);
    mux_2_single mux_2_18(w2[18], shiftamt[2], w1[18], w1[14]);
    mux_2_single mux_2_19(w2[19], shiftamt[2], w1[19], w1[15]);
    mux_2_single mux_2_20(w2[20], shiftamt[2], w1[20], w1[16]);
    mux_2_single mux_2_21(w2[21], shiftamt[2], w1[21], w1[17]);
    mux_2_single mux_2_22(w2[22], shiftamt[2], w1[22], w1[18]);
    mux_2_single mux_2_23(w2[23], shiftamt[2], w1[23], w1[19]);
    mux_2_single mux_2_24(w2[24], shiftamt[2], w1[24], w1[20]);
    mux_2_single mux_2_25(w2[25], shiftamt[2], w1[25], w1[21]);
    mux_2_single mux_2_26(w2[26], shiftamt[2], w1[26], w1[22]);
    mux_2_single mux_2_27(w2[27], shiftamt[2], w1[27], w1[23]);
    mux_2_single mux_2_28(w2[28], shiftamt[2], w1[28], w1[24]);
    mux_2_single mux_2_29(w2[29], shiftamt[2], w1[29], w1[25]);
    mux_2_single mux_2_30(w2[30], shiftamt[2], w1[30], w1[26]);
    mux_2_single mux_2_31(w2[31], shiftamt[2], w1[31], w1[27]);

    //Shift 8 bits
    mux_2_single mux_3_0(w3[0], shiftamt[3], w2[0], zero);
    mux_2_single mux_3_1(w3[1], shiftamt[3], w2[1], zero);
    mux_2_single mux_3_2(w3[2], shiftamt[3], w2[2], zero);
    mux_2_single mux_3_3(w3[3], shiftamt[3], w2[3], zero);
    mux_2_single mux_3_4(w3[4], shiftamt[3], w2[4], zero);
    mux_2_single mux_3_5(w3[5], shiftamt[3], w2[5], zero);
    mux_2_single mux_3_6(w3[6], shiftamt[3], w2[6], zero);
    mux_2_single mux_3_7(w3[7], shiftamt[3], w2[7], zero);
    mux_2_single mux_3_8(w3[8], shiftamt[3], w2[8], w2[0]);
    mux_2_single mux_3_9(w3[9], shiftamt[3], w2[9], w2[1]);
    mux_2_single mux_3_10(w3[10], shiftamt[3], w2[10], w2[2]);
    mux_2_single mux_3_11(w3[11], shiftamt[3], w2[11], w2[3]);
    mux_2_single mux_3_12(w3[12], shiftamt[3], w2[12], w2[4]);
    mux_2_single mux_3_13(w3[13], shiftamt[3], w2[13], w2[5]);
    mux_2_single mux_3_14(w3[14], shiftamt[3], w2[14], w2[6]);
    mux_2_single mux_3_15(w3[15], shiftamt[3], w2[15], w2[7]);
    mux_2_single mux_3_16(w3[16], shiftamt[3], w2[16], w2[8]);
    mux_2_single mux_3_17(w3[17], shiftamt[3], w2[17], w2[9]);
    mux_2_single mux_3_18(w3[18], shiftamt[3], w2[18], w2[10]);
    mux_2_single mux_3_19(w3[19], shiftamt[3], w2[19], w2[11]);
    mux_2_single mux_3_20(w3[20], shiftamt[3], w2[20], w2[12]);
    mux_2_single mux_3_21(w3[21], shiftamt[3], w2[21], w2[13]);
    mux_2_single mux_3_22(w3[22], shiftamt[3], w2[22], w2[14]);
    mux_2_single mux_3_23(w3[23], shiftamt[3], w2[23], w2[15]);
    mux_2_single mux_3_24(w3[24], shiftamt[3], w2[24], w2[16]);
    mux_2_single mux_3_25(w3[25], shiftamt[3], w2[25], w2[17]);
    mux_2_single mux_3_26(w3[26], shiftamt[3], w2[26], w2[18]);
    mux_2_single mux_3_27(w3[27], shiftamt[3], w2[27], w2[19]);
    mux_2_single mux_3_28(w3[28], shiftamt[3], w2[28], w2[20]);
    mux_2_single mux_3_29(w3[29], shiftamt[3], w2[29], w2[21]);
    mux_2_single mux_3_30(w3[30], shiftamt[3], w2[30], w2[22]);
    mux_2_single mux_3_31(w3[31], shiftamt[3], w2[31], w2[23]);

    //Shift 16 bits
    mux_2_single mux_4_0(result[0], shiftamt[4], w3[0], zero);
    mux_2_single mux_4_1(result[1], shiftamt[4], w3[1], zero);
    mux_2_single mux_4_2(result[2], shiftamt[4], w3[2], zero);
    mux_2_single mux_4_3(result[3], shiftamt[4], w3[3], zero);
    mux_2_single mux_4_4(result[4], shiftamt[4], w3[4], zero);
    mux_2_single mux_4_5(result[5], shiftamt[4], w3[5], zero);
    mux_2_single mux_4_6(result[6], shiftamt[4], w3[6], zero);
    mux_2_single mux_4_7(result[7], shiftamt[4], w3[7], zero);
    mux_2_single mux_4_8(result[8], shiftamt[4], w3[8], zero);
    mux_2_single mux_4_9(result[9], shiftamt[4], w3[9], zero);
    mux_2_single mux_4_10(result[10], shiftamt[4], w3[10], zero);
    mux_2_single mux_4_11(result[11], shiftamt[4], w3[11], zero);
    mux_2_single mux_4_12(result[12], shiftamt[4], w3[12], zero);
    mux_2_single mux_4_13(result[13], shiftamt[4], w3[13], zero);
    mux_2_single mux_4_14(result[14], shiftamt[4], w3[14], zero);
    mux_2_single mux_4_15(result[15], shiftamt[4], w3[15], zero);
    mux_2_single mux_4_16(result[16], shiftamt[4], w3[16], w3[0]);
    mux_2_single mux_4_17(result[17], shiftamt[4], w3[17], w3[1]);
    mux_2_single mux_4_18(result[18], shiftamt[4], w3[18], w3[2]);
    mux_2_single mux_4_19(result[19], shiftamt[4], w3[19], w3[3]);
    mux_2_single mux_4_20(result[20], shiftamt[4], w3[20], w3[4]);
    mux_2_single mux_4_21(result[21], shiftamt[4], w3[21], w3[5]);
    mux_2_single mux_4_22(result[22], shiftamt[4], w3[22], w3[6]);
    mux_2_single mux_4_23(result[23], shiftamt[4], w3[23], w3[7]);
    mux_2_single mux_4_24(result[24], shiftamt[4], w3[24], w3[8]);
    mux_2_single mux_4_25(result[25], shiftamt[4], w3[25], w3[9]);
    mux_2_single mux_4_26(result[26], shiftamt[4], w3[26], w3[10]);
    mux_2_single mux_4_27(result[27], shiftamt[4], w3[27], w3[11]);
    mux_2_single mux_4_28(result[28], shiftamt[4], w3[28], w3[12]);
    mux_2_single mux_4_29(result[29], shiftamt[4], w3[29], w3[13]);
    mux_2_single mux_4_30(result[30], shiftamt[4], w3[30], w3[14]);
    mux_2_single mux_4_31(result[31], shiftamt[4], w3[31], w3[15]);

endmodule