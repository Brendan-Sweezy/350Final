module m_control(write_en, data, writing, write_back, jal, opcode, dataB, loading, loadData, m_rd, w_rd, out, outdata);
        
    input loading;
    input[4:0] opcode, m_rd, w_rd;
    input[31:0] dataB, loadData, out, outdata;

    output write_en, writing, jal;
    output[31:0] data, write_back;

    wire is_add, is_addi, is_lw, is_jal;

    assign write_en = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0];

    assign is_add = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
    assign is_addi = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
    assign is_lw = ~opcode[4] && opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];

    assign writing = is_add || is_addi || is_lw || is_jal;
    assign data = loading && (m_rd === w_rd) ? loadData : dataB;

    assign write_back = is_lw ? outdata : out;

    assign jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];
    assign is_jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];

endmodule