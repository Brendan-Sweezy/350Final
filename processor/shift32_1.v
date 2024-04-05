module shift32_1 (S, A, en);

	input [31:0] A;
    input en;
    
    output [31:0] S;

    mux_2_single mux_0_0(S[0], en, A[0], 1'b0);
    mux_2_single mux_0_1(S[1], en, A[1], A[0]);
    mux_2_single mux_0_2(S[2], en, A[2], A[1]);
    mux_2_single mux_0_3(S[3], en, A[3], A[2]);
    mux_2_single mux_0_4(S[4], en, A[4], A[3]);
    mux_2_single mux_0_5(S[5], en, A[5], A[4]);
    mux_2_single mux_0_6(S[6], en, A[6], A[5]);
    mux_2_single mux_0_7(S[7], en, A[7], A[6]);
    mux_2_single mux_0_8(S[8], en, A[8], A[7]);
    mux_2_single mux_0_9(S[9], en, A[9], A[8]);
    mux_2_single mux_0_10(S[10], en, A[10], A[9]);
    mux_2_single mux_0_11(S[11], en, A[11], A[10]);
    mux_2_single mux_0_12(S[12], en, A[12], A[11]);
    mux_2_single mux_0_13(S[13], en, A[13], A[12]);
    mux_2_single mux_0_14(S[14], en, A[14], A[13]);
    mux_2_single mux_0_15(S[15], en, A[15], A[14]);
    mux_2_single mux_0_16(S[16], en, A[16], A[15]);
    mux_2_single mux_0_17(S[17], en, A[17], A[16]);
    mux_2_single mux_0_18(S[18], en, A[18], A[17]);
    mux_2_single mux_0_19(S[19], en, A[19], A[18]);
    mux_2_single mux_0_20(S[20], en, A[20], A[19]);
    mux_2_single mux_0_21(S[21], en, A[21], A[20]);
    mux_2_single mux_0_22(S[22], en, A[22], A[21]);
    mux_2_single mux_0_23(S[23], en, A[23], A[22]);
    mux_2_single mux_0_24(S[24], en, A[24], A[23]);
    mux_2_single mux_0_25(S[25], en, A[25], A[24]);
    mux_2_single mux_0_26(S[26], en, A[26], A[25]);
    mux_2_single mux_0_27(S[27], en, A[27], A[26]);
    mux_2_single mux_0_28(S[28], en, A[28], A[27]);
    mux_2_single mux_0_29(S[29], en, A[29], A[28]);
    mux_2_single mux_0_30(S[30], en, A[30], A[29]);
    mux_2_single mux_0_31(S[31], en, A[31], A[30]);


endmodule
