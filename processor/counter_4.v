module counter_4 (q, clk, clr);
   
   input clk, clr;
   output[1:0] q;

   wire [1:0] w0;

   tff tff0(.q(w0[0]), .clk(clk), .clr(clr), .t(1'b1));
   tff tff1(.q(w0[1]), .clk(clk), .clr(clr), .t(w0[0]));

   assign q[1:0] = w0[1:0];
   
endmodule