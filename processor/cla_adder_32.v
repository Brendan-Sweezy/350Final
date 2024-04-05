module cla_adder_32(A, B, c0, S, overflow);
        
    input [31:0] A, B;
    input c0;

    output [31:0] S;
    output overflow;

    wire c8, c16, c24;
    wire w0, w1, w2, w3, w4, w5;
    wire G0, G1, G2, G3;
    wire P0, P1, P2, P3;
    wire overflow0, overflow1, overflow2;

    cla_adder_8 block0(A[7:0], B[7:0], c0, S[7:0], G0, P0, overflow0);
    cla_adder_8 block1(A[15:8], B[15:8], c8, S[15:8], G1, P1, overflow1);
    cla_adder_8 block2(A[23:16], B[23:16], c16, S[23:16], G2, P2, overflow2);
    cla_adder_8 block3(A[31:24], B[31:24], c24, S[31:24], G3, P3, overflow);

    //c8 logic
    and and_0(w0, P0, c0);
    or or0(c8, G0, w0);

    //c16 logic
    and and_1(w1, P1, P0, c0);
    and and_2(w2, P1, G0);
    or or1(c16, G1, w1, w2);

    //c24 logic
    and and_3(w3, P2, P1, P0, c0);
    and and_4(w4, P2, P1, G0);
    and and_5(w5, P2, G1);
    or or2(c24, G2, w3, w4, w5);

endmodule