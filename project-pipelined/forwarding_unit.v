module forwarding_unit(mem_alu_out, wb_alu_out, mem_mem_out, wb_mem_out, mem_comp_result, wb_comp_result, mem_slbi_result,
        wb_slbi_result, mem_immediate, wb_immediate, mem_pc_add, wb_pc_add, mem_REG_WRITE, mem_write_r, mem_MEM_READ, 
        mem_COMP_REG, mem_SLBI, mem_LBI, mem_JUMP, wb_COMP_REG, wb_SLBI, wb_LBI, wb_JUMP, wb_REG_WRITE, wb_write_r, 
        wb_MEM_READ, ex_read_r1, ex_read_r2, alu_r1_wb, alu_r2_wb, alu_r1_mem, alu_r2_mem, mem_write_data, wb_write_data);

    input [15:0] mem_alu_out, wb_alu_out, mem_mem_out, wb_mem_out, mem_comp_result, wb_comp_result, mem_slbi_result,
            wb_slbi_result, mem_immediate, wb_immediate, mem_pc_add, wb_pc_add;
    input [2:0] mem_write_r, wb_write_r, ex_read_r1, ex_read_r2;
    input mem_REG_WRITE, mem_MEM_READ, mem_COMP_REG, mem_SLBI, mem_LBI, mem_JUMP, wb_COMP_REG, wb_SLBI, wb_LBI, wb_JUMP,
            wb_REG_WRITE, wb_MEM_READ;

    output [15:0] mem_write_data, wb_write_data;
    output alu_r1_wb, alu_r1_mem, alu_r2_wb, alu_r2_mem;

    wire [15:0] mem_alu_mem, mem_mem_alu_comp, mem_comp_slbi, mem_comp_lbi, wb_alu_mem, wb_mem_alu_comp, wb_comp_slbi,
                wb_comp_lbi;
    wire mem_matching_r1, mem_matching_r2, wb_matching_r1, wb_matching_r2;

    // write output for mem stage
    mux2_1 mem_alu_mem_mux [15:0] (.InA(mem_alu_out), .InB(mem_mem_out), .S(mem_MEM_READ), .Out(mem_alu_mem));
    mux2_1 mem_comp_mux [15:0] (.InA(mem_alu_mem), .InB(mem_comp_result), .S(mem_COMP_REG), .Out(mem_mem_alu_comp));
    mux2_1 mem_slbi_mux [15:0] (.InA(mem_mem_alu_comp), .InB(mem_slbi_result), .S(mem_SLBI), .Out(mem_comp_slbi));
    mux2_1 mem_lbi_mux [15:0] (.InA(mem_comp_slbi), .InB(mem_immediate), .S(mem_LBI), .Out(mem_comp_lbi));
    mux2_1 mem_jump_mux [15:0] (.InA(mem_comp_lbi), .InB(mem_pc_add), .S(mem_JUMP), .Out(mem_write_data));

    // write output for wb stage
    mux2_1 wb_alu_mem_mux [15:0] (.InA(wb_alu_out), .InB(wb_mem_out), .S(wb_MEM_READ), .Out(wb_alu_mem));
    mux2_1 wb_comp_mux [15:0] (.InA(wb_alu_mem), .InB(wb_comp_result), .S(wb_COMP_REG), .Out(wb_mem_alu_comp));
    mux2_1 wb_slbi_mux [15:0] (.InA(wb_mem_alu_comp), .InB(wb_slbi_result), .S(wb_SLBI), .Out(wb_comp_slbi));
    mux2_1 wb_lbi_mux [15:0] (.InA(wb_comp_slbi), .InB(wb_immediate), .S(wb_LBI), .Out(wb_comp_lbi));
    mux2_1 wb_jump_mux [15:0] (.InA(wb_comp_lbi), .InB(wb_pc_add), .S(wb_JUMP), .Out(wb_write_data));

    // select output from mem stage
    assign mem_matching_r1 = &(mem_write_r ^~ ex_read_r1);
    assign alu_r1_mem = mem_matching_r1 & mem_REG_WRITE;

    assign mem_matching_r2 = &(mem_write_r ^~ ex_read_r2);
    assign alu_r2_mem = mem_matching_r2 & mem_REG_WRITE;

    // select output from wb stage
    assign wb_matching_r1 = &(wb_write_r ^~ ex_read_r1);
    assign alu_r1_wb = wb_matching_r1 & wb_REG_WRITE;

    assign wb_matching_r2 = &(wb_write_r ^~ ex_read_r2);
    assign alu_r2_wb = wb_matching_r2 & wb_REG_WRITE;

endmodule

