module tristate_32(out, in, select);

	input [31:0] in;
    input select;

    output [31:0] out;

    assign out = select ? in : 32'bz;

endmodule
