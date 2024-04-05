module f_control(pc_next, opcode, pc_increment, target, pc_reg, do_jr, branch_target, do_branch, bex_target, bex_jump);
        
    input[31:0] pc_increment, pc_reg, branch_target, bex_target;
    input[26:0] target;
    input[4:0] opcode;
    input do_jr, do_branch, bex_jump;

    output[31:0] pc_next;

    wire[31:0] extended_target, pc_increment, selected_target, pc_next_temp, pc_next_temp2;
    wire is_j, is_jal, do_jump;

    assign is_j = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && opcode[0];
    assign is_jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];

    assign do_jump = is_j || is_jal || do_jr;

    assign selected_target = do_jr ? pc_reg : extended_target;
    assign pc_next_temp = do_jump ? selected_target : pc_increment;
    assign pc_next_temp2 = do_branch ? branch_target : pc_next_temp;
    assign pc_next = bex_jump ? bex_target : pc_next_temp2;

    assign extended_target[26:0] = target;
    assign extended_target[27] = target[26];
    assign extended_target[28] = target[26];
    assign extended_target[29] = target[26];
    assign extended_target[30] = target[26];
    assign extended_target[31] = target[26];

    
    
endmodule