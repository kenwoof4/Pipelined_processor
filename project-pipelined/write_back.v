module write_back(write_reg, mem_data, alu_out, pc_plus_2, immediate, slbi_or, comparison, COMPREG, LBI, SLBI, JUMP, MEMREAD);

    output [15:0] write_reg; // data to write to the register
    
    input[15:0] mem_data; // data from memory
    input [15:0] alu_out; // output from alu
    input [15:0] pc_plus_2; // current pc register plus 2
    input [15:0] immediate; // sign-extended immediate value
    input [15:0] slbi_or; // alu output or'ed with immedate value
    input [15:0] comparison;
    input COMPREG; // whether register comparison was made
    input LBI; // whether command is LBI
    input SLBI; // whether command is SLBI
    input JUMP; // if this is a jump command
    input MEMREAD; // whether memory was read

    wire [15:0] mem_or_alu; // either data memory or alu results
    wire comparison_lsb; // lsb of comparison data
    wire [15:0] comparison; // comparison data vector
    wire [15:0] data_or_comp; // either comparison data or mem_or_alu
    wire [15:0] data_comp_slbi; // either data_or_comp or read2 data
    wire [15:0] data_comp_slbi_imm; // either data_comp_slbi or immediate value

    mux2_1 data_choose [15:0] (.InA(alu_out), .InB(mem_data), .S(MEMREAD), .Out(mem_or_alu)); // picks between memory and alu data
    mux2_1 data_comparison_choose [15:0] (.InA(mem_or_alu), .InB(comparison), .S(COMPREG), .Out(data_or_comp)); // picks between last mux and comparison data

    mux2_1 data_comp_slbi_choose [15:0] (.InA(data_or_comp), .InB(slbi_or), .S(SLBI), .Out(data_comp_slbi)); // picks between last mux and slbi_or for slbi

    mux2_1 data_comp_slbi_imm_choose [15:0] (.InA(data_comp_slbi), .InB(immediate), .S(LBI), .Out(data_comp_slbi_imm));

    mux2_1 final_data_choose [15:0] (.InA(data_comp_slbi_imm), .InB(pc_plus_2), .S(JUMP), .Out(write_reg));

endmodule

