module register (q, d, clk, write, reset);

	input [31:0] d;
    input clk, write, reset;

    output [31:0] q;

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin: flip_flops
            dffe_ref dff(.q(q[i]), .d(d[i]), .clk(clk), .en(write), .clr(reset));
        end
    endgenerate

endmodule
