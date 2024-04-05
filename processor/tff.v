module tff (q, clk, t, clr);
   
   input clk, t, clr;
   output q;

   wire w0, w1, w2;
   wire q_wire;

   and and1(w0, ~t, q_wire);
   and and2(w1, t, ~q_wire);
   or or1(w2, w1, w0);

   dffe_ref dff(.q(q_wire), .d(w2), .clk(clk), .en(1'b1), .clr(clr));

   assign q = q_wire;
   
endmodule