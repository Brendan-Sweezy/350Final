module counter_64 (q, clk, clr);
   
   input clk, clr;
   output[6:0] q;

   wire [6:0] w0;

   tff tff0(.q(w0[0]), .clk(clk), .clr(clr), .t(1'b1));
   tff tff1(.q(w0[1]), .clk(clk), .clr(clr), .t(w0[0]));
   tff tff2(.q(w0[2]), .clk(clk), .clr(clr), .t(w0[0] && w0[1]));
   tff tff3(.q(w0[3]), .clk(clk), .clr(clr), .t(w0[0] && w0[1] && w0[2]));
   tff tff4(.q(w0[4]), .clk(clk), .clr(clr), .t(w0[0] && w0[1] && w0[2] && w0[3]));
   tff tff5(.q(w0[5]), .clk(clk), .clr(clr), .t(w0[0] && w0[1] && w0[2] && w0[3] && w0[4]));
   tff tff6(.q(w0[6]), .clk(clk), .clr(clr), .t(w0[0] && w0[1] && w0[2] && w0[3] && w0[4] && w0[5]));

   assign q[6:0] = w0[6:0];
   
endmodule