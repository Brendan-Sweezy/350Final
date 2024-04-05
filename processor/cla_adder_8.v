module cla_adder_8(A, B, c0, S, G, P, overflow);
        
    input [7:0] A, B;
    input c0;

    output [7:0] S;
    output G, P, overflow;

    wire [7:0] r;
    wire c1, c2, c3, c4, c5, c6, c7;
    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire p0, p1, p2, p3, p4, p5, p6, p7;
    wire w0_0, w1_0, w1_1, w2_0, w2_1, w2_2, w3_0, w3_1, w3_2, w3_3, w4_0, w4_1, w4_2, w4_3, w4_4;
    wire w5_0, w5_1, w5_2, w5_3, w5_4, w5_5, w6_0, w6_1, w6_2, w6_3, w6_4, w6_5, w6_6;
    wire wg_0, wg_1, wg_2, wg_3, wg_4, wg_5, wg_6, wg_7;
    wire wo_0, wo_1;


    //S return logic
    xor xor_S_0(r[0], A[0], B[0], c0);
    xor xor_S_1(r[1], A[1], B[1], c1);
    xor xor_S_2(r[2], A[2], B[2], c2);
    xor xor_S_3(r[3], A[3], B[3], c3);
    xor xor_S_4(r[4], A[4], B[4], c4);
    xor xor_S_5(r[5], A[5], B[5], c5);
    xor xor_S_6(r[6], A[6], B[6], c6);
    xor xor_S_7(r[7], A[7], B[7], c7);

    //g logic
    and and_g_0(g0, A[0], B[0]);
    and and_g_1(g1, A[1], B[1]);
    and and_g_2(g2, A[2], B[2]);
    and and_g_3(g3, A[3], B[3]);
    and and_g_4(g4, A[4], B[4]);
    and and_g_5(g5, A[5], B[5]);
    and and_g_6(g6, A[6], B[6]);
    and and_g_7(g7, A[7], B[7]);

    //p logic
    or or_p_0(p0, A[0], B[0]);
    or or_p_1(p1, A[1], B[1]);
    or or_p_2(p2, A[2], B[2]);
    or or_p_3(p3, A[3], B[3]);
    or or_p_4(p4, A[4], B[4]);
    or or_p_5(p5, A[5], B[5]);
    or or_p_6(p6, A[6], B[6]);
    or or_p_7(p7, A[7], B[7]);

    //c logic
    and and_c_0(w0_0, p0, c0);
    or or_c_0(c1, g0, w0_0);

    and and_c_1(w1_0, p1, p0, c0);
    and and_c_2(w1_1, p1, g0);
    or or_c_1(c2, g1, w1_0, w1_1);

    and and_c_3(w2_0, p2, p1, p0, c0);
    and and_c_4(w2_1, p2, p1, g0);
    and and_c_5(w2_2, p2, g1);
    or or_c_2(c3, g2, w2_0, w2_1, w2_2);

    and and_c_6(w3_0, p3, p2, p1, p0, c0);
    and and_c_7(w3_1, p3, p2, p1, g0);
    and and_c_8(w3_2, p3, p2, g1);
    and and_c_9(w3_3, p3, g2);
    or or_c_3(c4, g3, w3_0, w3_1, w3_2, w3_3);

    and and_c_10(w4_0, p4, p3, p2, p1, p0, c0);
    and and_c_11(w4_1, p4, p3, p2, p1, g0);
    and and_c_12(w4_2, p4, p3, p2, g1);
    and and_c_13(w4_3, p4, p3, g2);
    and and_c_14(w4_4, p4, g3);
    or or_c_4(c5, g4, w4_0, w4_1, w4_2, w4_3, w4_4);

    and and_c_15(w5_0, p5, p4, p3, p2, p1, p0, c0);
    and and_c_16(w5_1, p5, p4, p3, p2, p1, g0);
    and and_c_17(w5_2, p5, p4, p3, p2, g1);
    and and_c_18(w5_3, p5, p4, p3, g2);
    and and_c_19(w5_4, p5, p4, g3);
    and and_c_20(w5_5, p5, g4);
    or or_c_5(c6, g5, w5_0, w5_1, w5_2, w5_3, w5_4, w5_5);

    and and_c_21(w6_0, p6, p5, p4, p3, p2, p1, p0, c0);
    and and_c_22(w6_1, p6, p5, p4, p3, p2, p1, g0);
    and and_c_23(w6_2, p6, p5, p4, p3, p2, g1);
    and and_c_24(w6_3, p6, p5, p4, p3, g2);
    and and_c_25(w6_4, p6, p5, p4, g3);
    and and_c_26(w6_5, p6, p5, g4);
    and and_c_27(w6_6, p6, g5);
    or or_c_6(c7, g6, w6_0, w6_1, w6_2, w6_3, w6_4, w6_5, w6_6);

    //P logic
    and and_P(P, p0, p1, p2, p3, p4, p5, p6, p7);

    //G logic
    and and_G_0(wg_0, p7, p6, p5, p4, p3, p2, p1, g0);
    and and_G_1(wg_1, p7, p6, p5, p4, p3, p2, g1);
    and and_G_2(wg_2, p7, p6, p5, p4, p3, g2);
    and and_G_3(wg_3, p7, p6, p5, p4, g3);
    and and_G_4(wg_4, p7, p6, p5, g4);
    and and_G_5(wg_5, p7, p6, g5);
    and and_G_6(wg_6, p7, g6);
    or or_G(G, g7, wg_0, wg_1, wg_2, wg_3, wg_4, wg_5, wg_6);

    //overflow
    and and_test(wo_0, ~A[7], ~B[7], r[7]);
    and and_test1(wo_1, A[7], B[7], ~r[7]);
    or or_o(overflow, wo_0, wo_1);

    assign S = r;


endmodule