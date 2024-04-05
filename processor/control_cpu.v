module control_cpu(opcode, dataBImm, ALUopIn, ALUopOut);
        
    //dataBImm = ALU uses immediate
    
    input[4:0] opcode, ALUopIn;

    output[4:0] ALUopOut;
    output dataBImm;

    wire w_dataBImm;

    assign w_dataBImm = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
    assign dataBImm = w_dataBImm;
    assign ALUopOut = w_dataBImm ? 5'b0 : ALUopIn; 

endmodule