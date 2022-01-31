module id_ex_registers(read_r1_in, read_r2_in, write_r_in, imm_in, read_data_2_in, read_data_1_in, pc_add_in, 
        MEM_WRITE_in, MEM_READ_in, REG_WRITE_in, SLBI_in, LBI_in, JR_in, JUMP_in, COMP_TYPE_in, COMP_REG_in, BRANCH_CHOOSE_in, 
        BRANCH_in, IMM_USE_in, HALT_in, ALUop_in,read_r1_out, read_r2_out, write_r_out, imm_out, read_data_2_out, read_data_1_out, 
        pc_add_out, MEM_WRITE_out, MEM_READ_out, REG_WRITE_out, SLBI_out, LBI_out, JR_out, JUMP_out, 
        COMP_TYPE_out, COMP_REG_out, BRANCH_CHOOSE_out, BRANCH_out, IMM_USE_out, ALUop_out, HALT_out, clk, rst);

    input [15:0] imm_in, read_data_2_in, read_data_1_in, pc_add_in;
    input [2:0] read_r1_in, read_r2_in, write_r_in;
    input MEM_WRITE_in, MEM_READ_in, REG_WRITE_in, SLBI_in, LBI_in, JR_in, JUMP_in, COMP_REG_in,
            BRANCH_in, IMM_USE_in, HALT_in, clk, rst;
    input [3:0] ALUop_in;
    input [1:0] COMP_TYPE_in, BRANCH_CHOOSE_in;

    
    output [15:0] imm_out, read_data_2_out, read_data_1_out, pc_add_out;
    output [2:0] read_r1_out, read_r2_out, write_r_out;
    output  MEM_WRITE_out, MEM_READ_out, REG_WRITE_out, SLBI_out, LBI_out, JR_out, JUMP_out, COMP_REG_out,
            BRANCH_out, IMM_USE_out, HALT_out;
    output [3:0] ALUop_out;
    output [1:0] COMP_TYPE_out, BRANCH_CHOOSE_out;

    dff imm_register [15:0] (.q(imm_out), .d(imm_in), .clk(clk), .rst(rst));
    dff read_data_2_register [15:0] (.q(read_data_2_out), .d(read_data_2_in), .clk(clk), .rst(rst));
    dff read_data_1_register [15:0] (.q(read_data_1_out), .d(read_data_1_in), .clk(clk), .rst(rst));
    dff pc_add_register [15:0] (.q(pc_add_out), .d(pc_add_in), .clk(clk), .rst(rst));

    dff read_r1_register [2:0] (.q(read_r1_out), .d(read_r1_in), .clk(clk), .rst(rst));
    dff read_r2_register [2:0] (.q(read_r2_out), .d(read_r2_in), .clk(clk), .rst(rst));
    dff write_r_register [2:0] (.q(write_r_out), .d(write_r_in), .clk(clk), .rst(rst));

   
    dff MEM_WRITE_register(.q(MEM_WRITE_out), .d(MEM_WRITE_in), .clk(clk), .rst(rst));
    dff MEM_READ_register(.q(MEM_READ_out), .d(MEM_READ_in), .clk(clk), .rst(rst));
    dff REG_WRITE_register(.q(REG_WRITE_out), .d(REG_WRITE_in), .clk(clk), .rst(rst));
    dff SLBI_register(.q(SLBI_out), .d(SLBI_in), .clk(clk), .rst(rst));
    dff LBI_register(.q(LBI_out), .d(LBI_in), .clk(clk), .rst(rst));
    dff JR_register(.q(JR_out), .d(JR_in), .clk(clk), .rst(rst));
    dff JUMP_register(.q(JUMP_out), .d(JUMP_in), .clk(clk), .rst(rst));
    dff COMP_TYPE_register [1:0] (.q(COMP_TYPE_out), .d(COMP_TYPE_in), .clk(clk), .rst(rst));
    dff COMP_REG_register(.q(COMP_REG_out), .d(COMP_REG_in), .clk(clk), .rst(rst));
    dff BRANCH_CHOOSE_register [1:0] (.q(BRANCH_CHOOSE_out), .d(BRANCH_CHOOSE_in), .clk(clk), .rst(rst));
    dff BRANCH_register(.q(BRANCH_out), .d(BRANCH_in), .clk(clk), .rst(rst));
    dff IMM_USE_register(.q(IMM_USE_out), .d(IMM_USE_in), .clk(clk), .rst(rst));
    dff HALT_register(.q(HALT_out), .d(HALT_in), .clk(clk), .rst(rst));

    dff ALUop_register [3:0] (.q(ALUop_out), .d(ALUop_in), .clk(clk), .rst(rst));

endmodule

