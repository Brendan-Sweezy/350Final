module x_control(x_res, ALU_dataB, ALU_dataA, ALUopOut, do_branch, do_jump, shifted_target, continue, overflow, writing, loading, error_code, jal, opcode, ALUopIn, data_B, data_A, shifted_immediate, is_less, is_neq, pc, target, muldiv_ready, ALU_res, muldiv_res, muldivov, ALUov);
        
    //dataBImm = ALU uses immediate
    input is_less, is_neq, muldiv_ready, muldivov, ALUov;
    input[4:0] opcode, ALUopIn;
    input[26:0] target;
    input[31:0] data_B, data_A, shifted_immediate, pc, ALU_res, muldiv_res;

    output[4:0] ALUopOut;
    output [31:0] ALU_dataB, ALU_dataA, shifted_target, x_res, error_code;
    output jal, do_branch, do_jump, continue, overflow, writing, loading;

    wire w_dataBImm, is_bne, is_blt, is_bex, is_mul, is_div, is_add, is_addi, is_lw, is_true_add, is_sub;
    wire[31:0] extended_target, shifted_immediate_plus1, ALU_dataB_temp;

    assign jal = is_jal;
    
    wire is_jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];
    assign is_bne = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && ~opcode[0];
    assign is_blt = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
    assign is_bex = opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
    assign is_mul = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0] && ~ALUopIn[4] && ~ALUopIn[3] && ALUopIn[2] && ALUopIn[1] && ~ALUopIn[0];
    assign is_div = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0] && ~ALUopIn[4] && ~ALUopIn[3] && ALUopIn[2] && ALUopIn[1] && ALUopIn[0];
    assign is_lw = ~opcode[4] && opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];

    assign w_dataBImm = is_blt || is_bne || (~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0]) || (~opcode[4] && opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0]) || (~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0]);
    assign ALUopOut = (w_dataBImm || is_jal) ? 5'b0 : ALUopIn; 

    assign do_branch = (is_bne && is_neq) || (is_blt && is_less);

    mux_2 select_dataB(.out(ALU_dataB_temp), .select(w_dataBImm), .in0(data_B), .in1(shifted_immediate));
    assign ALU_dataB = is_blt || is_bne ? shifted_immediate_plus1 : ALU_dataB_temp;

    cla_adder_32 PC_Add(.A(32'b0), .B(shifted_immediate), .c0(1'b1), .S(shifted_immediate_plus1), .overflow());

    assign ALU_dataA = is_blt || is_bne ? pc : data_A;

    assign shifted_target[26:0] = target;
    assign shifted_target[27] = target[26];
    assign shifted_target[28] = target[26];
    assign shifted_target[29] = target[26];
    assign shifted_target[30] = target[26];
    assign shifted_target[31] = target[26];

    assign do_jump = is_bex && is_neq;

    assign continue = (~is_div && ~is_mul) || muldiv_ready;

    assign x_res = is_mul || is_div ? muldiv_res : ALU_res;

    assign overflow = (is_mul || is_div ? muldivov : ALUov) && (is_add || is_addi);

    assign is_add = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
    assign is_addi = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
    assign writing = is_add || is_addi || is_jal;

    assign loading = is_lw;

    assign error_code[0] = is_true_add || is_sub || is_div;
    assign error_code[1] = is_addi || is_sub;
    assign error_code[2] = is_mul || is_div;
    assign error_code[31:3] = 30'b00000000000000000000000000000;

    assign is_true_add = is_add && ~ALUopOut[4] && ~ALUopOut[3] && ~ALUopOut[2] && ~ALUopOut[1] && ~ALUopOut[0];
    assign is_sub = is_add && ~ALUopOut[4] && ~ALUopOut[3] && ~ALUopOut[2] && ~ALUopOut[1] && ALUopOut[0];
    //assign is_mul = is_add && ~ALUopOut[4] && ~ALUopOut[3] && ALUopOut[2] && ALUopOut[1] && ~ALUopOut[0];
    //assign is_div = is_add && ~ALUopOut[4] && ~ALUopOut[3] && ALUopOut[2] && ALUopOut[1] && ALUopOut[0];

endmodule