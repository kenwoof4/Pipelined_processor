/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines

   wire [15:0] pc_execute, reg_data, mem_write_forwarding, wb_write_forwarding; // doesn't change with registers
   wire stall, jump_hazard, alu_r1_mem_forwarding, alu_r2_mem_forwarding, alu_r1_wb_forwarding,
            alu_r2_wb_forwarding; // doesn't change with registers

   // IF wires
   wire [15:0] pc_add0, instr;
   wire Halt; 


   // ID wires
   wire [15:0] id_instr, id_immediate, id_pc, id_read_data_r1, id_read_data_r2;
   wire id_IMM, id_BRANCH, id_COMP_REG, id_isJUMP, id_isJR, id_isLBI, id_isSLBI, 
            id_MEM_R, id_MEM_W,id_REG_W, id_HALT;
   wire [3:0] id_ALUop;
   wire [2:0] id_write_r;
   wire [1:0] id_COMP_TYPE, id_BRANCH_CHOOSE;

   // EX wires
   wire [15:0] Alu_result, ex_slbi_result, ex_immediate, ex_pc, ex_comparison, ex_read_data_1, ex_read_data_2, ex_r2_forward;
   wire [2:0] ex_read_r1, ex_read_r2, ex_write_r;
   wire [3:0] ex_ALUop;
   wire [1:0] ex_COMP_TYPE, ex_BRANCH_CHOOSE;
   wire ex_COMP_REG, ex_IMM_USE, ex_SLBI, ex_isBRANCH, ex_isJUMP, ex_JR, ex_MEM_W, ex_MEM_R,
            ex_REG_W, ex_isLBI, ex_HALT;

   // MEM wires
   wire [15:0] mem_mem_out, mem_alu_out, mem_read_data_2, mem_pc, mem_slbi_result, mem_comparison, mem_immediate;
   wire mem_MEM_W, mem_MEM_R, mem_isLBI, mem_isSLBI, mem_COMP_REG, mem_REG_W, mem_isJUMP, mem_HALT;
   wire [2:0] mem_write_r;

   // WB wires
   wire [15:0] wb_mem_out, wb_alu_out, wb_pc, wb_immediate, wb_slbi_result, wb_comparison;
   wire wb_isLBI, wb_isSLBI, wb_isJUMP, wb_MEM_R, wb_REG_W, wb_HALT;
   wire [2:0] wb_write_r;
   
   
   
   instr_fetch instr_fetch1(.pc_add(pc_add0), .instr_next(instr), .HALT_out(Halt), .err(instr_fetch_err),
         .clk(clk), .rst(rst), .pc_execute(pc_execute), .HALT_in(wb_HALT), .stall(stall), .jump_hazard(jump_hazard),
         .JUMP_id(id_isJUMP), .BRANCH_id(id_BRANCH), .JUMP_ex(ex_isJUMP), .BRANCH_ex(ex_isBRANCH));

   if_id_registers if_id(.pc_add_in(pc_add0), .instr_in(instr), .HALT_in(Halt), .pc_add_out(id_pc), 
         .instr_out(id_instr), .HALT_out(id_HALT), .stall(stall), .jump_hazard(jump_hazard), .clk(clk), .rst(rst));


   instr_decode instr_decode1(.instruction(id_instr), .to_write(reg_data), .write_register_in(wb_write_r),
         .REG_WRITE_in(wb_REG_W), .id_HALT(id_HALT), .clk(clk), .rst(rst), .IMM_USE(id_IMM), .BRANCH(id_BRANCH), 
         .BRANCH_CHOOSE(id_BRANCH_CHOOSE), .COMP_REG(id_COMP_REG), .COMP_TYPE(id_COMP_TYPE), .JUMP(id_isJUMP), .JR(id_isJR), 
         .LBI(id_isLBI), .SLBI(id_isSLBI), .MEM_READ(id_MEM_R), .MEM_WRITE(id_MEM_W), .ALUop(id_ALUop), 
         .read_data_1(id_read_data_r1), .read_data_2(id_read_data_r2), .immediate(id_immediate), 
         .write_register_out(id_write_r), .REG_WRITE_out(id_REG_W), .err(err));
  
   hazard_detection hazard_detection1(.JUMP_ex(ex_isJUMP), .BRANCH_ex(ex_isBRANCH), .JUMP_id(id_isJUMP), .BRANCH_id(id_BRANCH), 
         .HALT_id(id_HALT), .HALT_ex(ex_HALT), .HALT_mem(mem_HALT), .HALT_wb(wb_HALT), .jump_hazard(jump_hazard), .stall(stall));

   id_ex_registers id_ex1(.read_r1_in(id_instr[10:8]), .read_r2_in(id_instr[7:5]), .write_r_in(id_write_r),
        .imm_in(id_immediate), .read_data_2_in(id_read_data_r2), .read_data_1_in(id_read_data_r1), .pc_add_in(id_pc),
        .MEM_WRITE_in(id_MEM_W), .MEM_READ_in(id_MEM_R), .REG_WRITE_in(id_REG_W), .SLBI_in(id_isSLBI), 
        .LBI_in(id_isLBI), .JR_in(id_isJR), .JUMP_in(id_isJUMP), .COMP_TYPE_in(id_COMP_TYPE), .COMP_REG_in(id_COMP_REG), 
        .BRANCH_CHOOSE_in(id_BRANCH_CHOOSE), .BRANCH_in(id_BRANCH), .IMM_USE_in(id_IMM), .HALT_in(id_HALT),
        .ALUop_in(id_ALUop), .read_r1_out(ex_read_r1), .read_r2_out(ex_read_r2), .write_r_out(ex_write_r), 
        .imm_out(ex_immediate), .read_data_2_out(ex_read_data_2), .read_data_1_out(ex_read_data_1), .pc_add_out(ex_pc), 
        .MEM_WRITE_out(ex_MEM_W), .MEM_READ_out(ex_MEM_R), .REG_WRITE_out(ex_REG_W), .SLBI_out(ex_SLBI), 
        .LBI_out(ex_isLBI), .JR_out(ex_JR), .JUMP_out(ex_isJUMP), .COMP_TYPE_out(ex_COMP_TYPE), .COMP_REG_out(ex_COMP_REG), 
        .BRANCH_CHOOSE_out(ex_BRANCH_CHOOSE), .BRANCH_out(ex_isBRANCH), .IMM_USE_out(ex_IMM_USE), 
        .HALT_out(ex_HALT), .ALUop_out(ex_ALUop), .clk(clk), .rst(rst));

   instr_execute instr_execute1(.alu_out(Alu_result), .slbi_or(ex_slbi_result), .err(instr_execute_err), 
         .pc_next(pc_execute), .comparison(ex_comparison), .mem_forward_result_r2(ex_r2_forward), .read_data_1(ex_read_data_1), 
         .read_data_2(ex_read_data_2), .mem_forwarded(mem_write_forwarding), .wb_forwarded(wb_write_forwarding), 
         .immediate(ex_immediate), .ALUop(ex_ALUop), .COMP_REG(ex_COMP_REG), .COMP_TYPE(ex_COMP_TYPE), .IMM_USE(ex_IMM_USE), 
         .SLBI(ex_SLBI), .BRANCH(ex_isBRANCH), .BRANCH_CHOOSE(ex_BRANCH_CHOOSE), .JUMP(ex_isJUMP), .JR(ex_JR), 
         .r1_mem_forward(alu_r1_mem_forwarding), .r2_mem_forward(alu_r2_mem_forwarding), .r1_wb_forward(alu_r1_wb_forwarding), 
         .r2_wb_forward(alu_r2_wb_forwarding), .pc_add(ex_pc));

   ex_mem_registers ex_mem1(.pc_add_in(ex_pc), .read_data_2_in(ex_r2_forward), .write_r_in(ex_write_r), 
        .slbi_result_in(ex_slbi_result), .alu_out_in(Alu_result), .compare_in(ex_comparison), .immediate_in(ex_immediate),
        .LBI_in(ex_isLBI), .SLBI_in(ex_SLBI), .COMP_REG_in(ex_COMP_REG), .REG_WRITE_in(ex_REG_W), .MEM_WRITE_in(ex_MEM_W),
        .MEM_READ_in(ex_MEM_R), .JUMP_in(ex_isJUMP), .HALT_in(ex_HALT), .pc_add_out(mem_pc), 
        .read_data_2_out(mem_read_data_2), .write_r_out(mem_write_r), .slbi_result_out(mem_slbi_result), 
        .alu_out_out(mem_alu_out), .compare_out(mem_comparison), .immediate_out(mem_immediate), .LBI_out(mem_isLBI), 
        .SLBI_out(mem_isSLBI), .COMP_REG_out(mem_COMP_REG), .REG_WRITE_out(mem_REG_W), .MEM_WRITE_out(mem_MEM_W), 
        .MEM_READ_out(mem_MEM_R), .JUMP_out(mem_isJUMP), .HALT_out(mem_HALT), .clk(clk), .rst(rst));

   forwarding_unit forwarding_unit1(.mem_alu_out(mem_alu_out), .wb_alu_out(wb_alu_out), .mem_mem_out(mem_mem_out), 
        .wb_mem_out(wb_mem_out), .mem_comp_result(mem_comparison), .wb_comp_result(wb_comparison), 
        .mem_slbi_result(mem_slbi_result), .wb_slbi_result(wb_slbi_result), .mem_immediate(mem_immediate), 
        .wb_immediate(wb_immediate), .mem_pc_add(mem_pc), .wb_pc_add(wb_pc), .mem_REG_WRITE(mem_REG_W), 
        .mem_write_r(mem_write_r), .mem_MEM_READ(mem_MEM_R), .mem_COMP_REG(mem_COMP_REG), .mem_SLBI(mem_isSLBI), 
        .mem_LBI(mem_isLBI), .mem_JUMP(mem_isJUMP), .wb_COMP_REG(wb_COMP_REG), .wb_SLBI(wb_isSLBI), .wb_LBI(wb_isLBI), .wb_JUMP(wb_isJUMP), 
        .wb_REG_WRITE(wb_REG_W), .wb_write_r(wb_write_r), .wb_MEM_READ(wb_MEM_R), .ex_read_r1(ex_read_r1), 
        .ex_read_r2(ex_read_r2), .alu_r1_wb(alu_r1_wb_forwarding), .alu_r2_wb(alu_r2_wb_forwarding), 
        .alu_r1_mem(alu_r1_mem_forwarding), .alu_r2_mem(alu_r2_mem_forwarding), .mem_write_data(mem_write_forwarding), 
        .wb_write_data(wb_write_forwarding));

   memory memory1(.read_data(mem_mem_out), .err(memory_err), .addr(mem_alu_out), .write_data(mem_read_data_2), 
         .MEM_WRITE(mem_MEM_W), .MEM_READ(mem_MEM_R), .clk(clk), .rst(rst), .HALT(wb_HALT));

   mem_wb_registers mem_wb1(.pc_add_in(mem_pc), .write_r_in(mem_write_r), .compare_in(mem_comparison), 
        .slbi_result_in(mem_slbi_result), .immediate_in(mem_immediate), .mem_result_in(mem_mem_out), .alu_out_in(mem_alu_out),
        .JUMP_in(mem_isJUMP), .LBI_in(mem_isLBI), .SLBI_in(mem_isSLBI), .REG_WRITE_in(mem_REG_W), .COMP_REG_in(mem_COMP_REG), 
        .MEM_READ_in(mem_MEM_R),.HALT_in(mem_HALT), .pc_add_out(wb_pc), .write_r_out(wb_write_r), 
        .compare_out(wb_comparison), .slbi_result_out(wb_slbi_result), .immediate_out(wb_immediate), 
        .mem_result_out(wb_mem_out), .alu_out_out(wb_alu_out), .JUMP_out(wb_isJUMP), .LBI_out(wb_isLBI), .SLBI_out(wb_isSLBI), 
        .REG_WRITE_out(wb_REG_W), .COMP_REG_out(wb_COMP_REG), .MEM_READ_out(wb_MEM_R), .HALT_out(wb_HALT), 
        .clk(clk), .rst(rst));

   write_back write_back1 (.write_reg(reg_data), .mem_data(wb_mem_out), .alu_out(wb_alu_out), .pc_plus_2(wb_pc),
      .immediate(wb_immediate), .slbi_or(wb_slbi_result), .comparison(wb_comparison), .COMPREG(wb_COMP_REG), .LBI(wb_isLBI),
      .SLBI(wb_isSLBI), .JUMP(wb_isJUMP), .MEMREAD(wb_MEM_R));

assign err = instr_fetch_err | memory_err | instr_execute_err;
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0: