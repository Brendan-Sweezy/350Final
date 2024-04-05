module div_bit (A, S, q);
   
    input q, z;
    input [63:0] A;
    output[63:0] S;

    assign S[63:2] = A[63:2];
    assign S[1] = q;

    assign S[0] = A[0];
   
endmodule