module d_control(readA, readB, dataA, dataB, do_jr, stall, opcode, rs, rt, rd, pc, dataAin, dataBin, x_rd, x_res, x_writ, m_rd, m_res, m_writ, loading, overflow, x_jal, m_jal);
        
    input[31:0] pc, dataAin, dataBin, x_res, m_res;
    input[4:0] opcode, rt, rd, rs, x_rd, m_rd;
    input x_writ, m_writ, loading, overflow, x_jal, m_jal;

    output[31:0] dataA, dataB;
    output[4:0] readB, readA;
    output do_jr, stall;

    wire[31:0] dataB_temp, dataA_haz, dataB_haz, a_dependency, b_dependency;
    
    wire is_add, is_addi, is_sw, is_jal, is_jr, is_blt, is_bne, is_bex, is_depAm, is_depAx, is_depBm, is_depBx;
    
    assign is_sw = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0];
    assign is_jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];
    assign is_jr = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && ~opcode[0];
    assign is_bne = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && ~opcode[0];
    assign is_blt = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
    assign is_bex = opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
    assign is_add = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
    assign is_addi = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];

    assign readB = is_sw || is_jr || is_blt || is_bne ? rd : rt;
    assign readA = is_bex ? 5'b11110 : rs;

    assign dataA_haz = is_jal ? pc : dataAin;
    assign dataB_temp = is_jal ? 32'b00000000000000000000000000000001 : dataBin; //I dont know why this isn't 1!?!??!!
    assign dataB_haz = is_bex ? 32'b00000000000000000000000000000000 : dataB_temp;

    assign do_jr = is_jr;

    assign is_depAx = ((x_rd == readA || (overflow && readA == 5'b11110) || (x_jal && readA == 5'b11111)) && x_writ && readA != 5'b0);
    assign is_depAm = ((m_rd == readA || (m_jal && readA == 5'b11111)) && m_writ && readA != 5'b0);
    assign is_depBx = ((x_rd == readB || (overflow && readB == 5'b11110) || (x_jal && readB == 5'b11111)) && x_writ && readB != 5'b0);
    assign is_depBm = ((m_rd == readB || (m_jal && readB == 5'b11111)) && m_writ && readB != 5'b0);
    
    assign a_dependency = is_depAx ? x_res : m_res;
    assign dataA = is_depAm || is_depAx ? a_dependency : dataA_haz;

    assign b_dependency = is_depBx ? x_res : m_res;
    assign dataB = is_depBm || is_depBx ? b_dependency : dataB_haz;

    assign stall = (is_add || is_addi || is_jr || is_bne || is_blt) && loading;

endmodule