module sign_extender(A, S);
        
    input [16:0] A;
    
    output [31:0] S;

    assign S[16:0] = A;
    assign S[17] = A[16];
    assign S[18] = A[16];
    assign S[19] = A[16];
    assign S[20] = A[16];
    assign S[21] = A[16];
    assign S[22] = A[16];
    assign S[23] = A[16];
    assign S[24] = A[16];
    assign S[25] = A[16];
    assign S[26] = A[16];
    assign S[27] = A[16];
    assign S[28] = A[16];
    assign S[29] = A[16];
    assign S[30] = A[16];
    assign S[31] = A[16];

endmodule