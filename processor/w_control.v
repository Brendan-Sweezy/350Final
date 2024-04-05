module w_control(write_data, write_ctrl, write_reg, loading, D, O, opcode, rd, target, overflow, ALUop);
        
    input[31:0] D, O;
    input[26:0] target;
    input[4:0] opcode, rd, ALUop;
    input overflow;

    output[31:0] write_data;
    output[4:0] write_reg;
    output write_ctrl, loading;

    wire[31:0] extended_target, write_data_temp, error_code, write_data_temp2;
    wire[4:0] write_reg_temp;
    wire[2:0] error_select;
    wire is_lw, is_add, is_addi, is_jal, is_setx, is_true_add, is_sub, is_mul, is_div;
    
    assign is_lw = ~opcode[4] && opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
    assign is_add = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
    assign is_addi = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
    assign is_jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];
    assign is_setx = opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
    assign is_true_add = is_add && ~ALUop[4] && ~ALUop[3] && ~ALUop[2] && ~ALUop[1] && ~ALUop[0];
    assign is_sub = is_add && ~ALUop[4] && ~ALUop[3] && ~ALUop[2] && ~ALUop[1] && ALUop[0];
    assign is_mul = is_add && ~ALUop[4] && ~ALUop[3] && ALUop[2] && ALUop[1] && ~ALUop[0];
    assign is_div = is_add && ~ALUop[4] && ~ALUop[3] && ALUop[2] && ALUop[1] && ALUop[0];

    assign write_ctrl = is_lw || is_add || is_addi || is_jal || is_setx;

    assign write_data_temp = is_lw ? D : O;
    assign write_data_temp2 = is_setx ? extended_target : write_data_temp;
    assign write_data = ((is_true_add || is_addi || is_sub || is_mul || is_div) && overflow) ? error_code : write_data_temp2;

    assign write_reg_temp = is_jal ? 5'b11111 : rd;
    assign write_reg = is_setx || ((is_true_add || is_addi || is_sub || is_mul || is_div) && overflow) ? 5'b11110 : write_reg_temp;

    assign extended_target[26:0] = target;
    assign extended_target[27] = target[26];
    assign extended_target[28] = target[26];
    assign extended_target[29] = target[26];
    assign extended_target[30] = target[26];
    assign extended_target[31] = target[26];

    assign error_code[0] = is_true_add || is_sub || is_div;
    assign error_code[1] = is_addi || is_sub;
    assign error_code[2] = is_mul || is_div;
    assign error_code[31:3] = 30'b00000000000000000000000000000;
    
    assign loading = is_lw;

endmodule