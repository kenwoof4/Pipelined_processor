module ex_mem_registers(pc_add_in, read_data_2_in, write_r_in, slbi_result_in, alu_out_in, compare_in, immediate_in, LBI_in,
        SLBI_in, COMP_REG_in, REG_WRITE_in, MEM_WRITE_in, MEM_READ_in, JUMP_in, HALT_in, pc_add_out, read_data_2_out, 
        write_r_out, slbi_result_out, alu_out_out, compare_out, immediate_out, LBI_out, SLBI_out, COMP_REG_out, REG_WRITE_out, 
        MEM_WRITE_out, MEM_READ_out, JUMP_out, HALT_out, clk, rst);

    input [15:0] pc_add_in, read_data_2_in, slbi_result_in, alu_out_in, compare_in, immediate_in; 
    input [2:0] write_r_in;
    input LBI_in, SLBI_in, COMP_REG_in, REG_WRITE_in, MEM_WRITE_in, MEM_READ_in, JUMP_in, HALT_in, clk, rst;

    output [15:0] pc_add_out, read_data_2_out, slbi_result_out, alu_out_out, compare_out, immediate_out; 
    output [2:0] write_r_out;
    output LBI_out, SLBI_out, COMP_REG_out, REG_WRITE_out, MEM_WRITE_out, MEM_READ_out, JUMP_out, HALT_out;

    dff pc_add_register [15:0] (.q(pc_add_out), .d(pc_add_in), .clk(clk), .rst(rst));
    dff read_data_2_register [15:0] (.q(read_data_2_out), .d(read_data_2_in), .clk(clk), .rst(rst));
    dff slbi_result_register [15:0] (.q(slbi_result_out), .d(slbi_result_in), .clk(clk), .rst(rst));
    dff alu_out_register [15:0] (.q(alu_out_out), .d(alu_out_in), .clk(clk), .rst(rst));
    dff compare_register [15:0] (.q(compare_out), .d(compare_in), .clk(clk), .rst(rst));
    dff immediate_register [15:0] (.q(immediate_out), .d(immediate_in), .clk(clk), .rst(rst));

    dff write_r_register [2:0] (.q(write_r_out), .d(write_r_in), .clk(clk), .rst(rst));

    dff LBI_register(.q(LBI_out), .d(LBI_in), .clk(clk), .rst(rst));
    dff SLBI_register(.q(SLBI_out), .d(SLBI_in), .clk(clk), .rst(rst));
    dff COMP_REG_register(.q(COMP_REG_out), .d(COMP_REG_in), .clk(clk), .rst(rst));
    dff REG_WRITE_register(.q(REG_WRITE_out), .d(REG_WRITE_in), .clk(clk), .rst(rst));
    dff MEM_WRITE_register(.q(MEM_WRITE_out), .d(MEM_WRITE_in), .clk(clk), .rst(rst));
    dff MEM_READ_register(.q(MEM_READ_out), .d(MEM_READ_in), .clk(clk), .rst(rst));
    dff JUMP_register(.q(JUMP_out), .d(JUMP_in), .clk(clk), .rst(rst));
    dff HALT_register(.q(HALT_out), .d(HALT_in), .clk(clk), .rst(rst));

endmodule
