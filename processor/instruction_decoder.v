module instruction_decoder(instruction, opcode, rd, rs, rt, shamt, ALUop, target, shifted_immediate);
        
    input [31:0] instruction;

    output [4:0] opcode, rd, rs, rt, shamt, ALUop;
    output [26:0] target;
    output [31:0] shifted_immediate;

    wire [16:0] immediate;

    assign opcode = instruction[31:27];
    assign rd = instruction[26:22];
    assign rs = instruction[21:17];
    assign rt = instruction[16:12];
    assign shamt = instruction[11:7];
    assign ALUop = instruction[6:2];
    assign immediate = instruction[16:0];
    assign target = instruction[26:0];
    
    sign_extender extendImm(.A(immediate), .S(shifted_immediate));

    

endmodule