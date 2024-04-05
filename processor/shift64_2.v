module shift64_2 (q, d, extra);

	input [63:0] d;
    
    output [63:0] q;
    output extra;

    assign q[61:0] = d[63:2];
    assign q[62] = d[63];
    assign q[63] = d[63];
    assign extra = d[1];


endmodule
