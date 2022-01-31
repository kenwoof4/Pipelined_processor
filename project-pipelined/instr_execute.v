module instr_execute(alu_out, slbi_or, err, pc_next, comparison, mem_forward_result_r2, read_data_1, read_data_2, 
                    mem_forwarded, wb_forwarded, immediate, ALUop, COMP_REG, COMP_TYPE, IMM_USE, SLBI, BRANCH, BRANCH_CHOOSE, 
                    r1_mem_forward, r2_mem_forward, r1_wb_forward, r2_wb_forward, JUMP, JR, pc_add);

    output [15:0] alu_out; // output of the alu
    output [15:0] slbi_or; // alu output or'ed with the extended immediate for the slbi instruction
    output err; // if there was a hardware error
    output [15:0] pc_next; // final calculation for pc
    output [15:0] comparison;
    output [15:0] mem_forward_result_r2;
    
    input [15:0] read_data_1, read_data_2, immediate; // data from registers and immediate value
    input [3:0] ALUop; // ALU opcode
    input COMP_REG; // whether this is a compare instruction
    input [1:0] COMP_TYPE;
    input IMM_USE; // whether to use the immediate value in the second alu input
    input SLBI;  // whether the instruction is SLBI
    input BRANCH; // whether the instruction is a Branch
    input [1:0] BRANCH_CHOOSE; // which branch to take
    input JUMP; // whether the instruction is a Jump
    input JR; // whether the instruction is a JR
    input [15:0] pc_add; // PC value incremented by 2
    input [15:0] mem_forwarded;
    input [15:0] wb_forwarded;
    input r1_mem_forward, r2_mem_forward, r1_wb_forward, r2_wb_forward;


    wire Zero; // Zero flag
    wire Neg; // Negative flag
    wire LT; // less than flag
    wire Cout; // whether overflow occured
    wire [15:0] A_in, data_2_or_not, data_or_imm, data_imm_slbi, B_in, pc_plus_imm, pc_two_or_jump, wb_forward_result_r1,
            mem_forward_result_r1, wb_forward_result_r2;
    wire is_subtraction, is_and, Cin, branch_mux, comparison_lsb;

    assign is_subtraction = ~(|ALUop[3:1]) & ALUop[0];
    assign is_and = ~(|ALUop[3:2]) & (&ALUop[1:0]);


    // forwarding logic
    mux2_1 r1_wb_forward_mux [15:0] (.InA(read_data_1), .InB(wb_forwarded), .S(r1_wb_forward), .Out(wb_forward_result_r1));
    mux2_1 r1_mem_forward_mux [15:0] (.InA(wb_forward_result_r1), .InB(mem_forwarded), .S(r1_mem_forward), 
            .Out(mem_forward_result_r1));

    mux2_1 r2_wb_forward_mux [15:0] (.InA(read_data_2), .InB(wb_forwarded), .S(r2_wb_forward), .Out(wb_forward_result_r2));
    mux2_1 r2_mem_forward_mux [15:0] (.InA(wb_forward_result_r2), .InB(mem_forwarded), .S(r2_mem_forward),
            .Out(mem_forward_result_r2));

    // alu input logic
    mux2_1 A_in_mux [15:0] (.InA(mem_forward_result_r1), .InB(~mem_forward_result_r1), .S(is_subtraction & ~COMP_REG), 
            .Out(A_in));
    mux2_1 data_or_imm_mux [15:0](.InA(mem_forward_result_r2), .InB(immediate), .S(IMM_USE), .Out(data_or_imm));
    mux2_1 data_2_or_not_mux [15:0] (.InA(data_or_imm), .InB(~data_or_imm), .S(is_and | (COMP_REG & is_subtraction)),
    .Out(data_2_or_not));
    mux2_1 data_imm_slbi_mux [15:0] (.InA(data_2_or_not), .InB(16'h8), .S(SLBI), .Out(data_imm_slbi));
    mux2_1 B_in_mux [15:0] (.InA(data_imm_slbi), .InB(16'b0), .S(BRANCH), .Out(B_in));

    mux2_1 carry_in_mux (.InA(1'b0), .InB(1'b1), .S(is_subtraction), .Out(Cin));

    alu alu_1 (.Out(alu_out), .Zero(Zero), .Neg(Neg), .Cout(Cout), .A(A_in), .B(B_in), .Cin(Cin), .ALUop(ALUop));

    assign slbi_or = alu_out | immediate;

    assign LT = COMP_REG & ((mem_forward_result_r1[15] & ~mem_forward_result_r2[15]) | Neg);

    mux4_1 branch (.InA(Zero), .InB(~Zero), .InC(Neg), .InD(~Neg), .S(BRANCH_CHOOSE), .Out(branch_mux));

    cla_16bit pc_add_imm (.A(pc_add), .B(immediate), .Cin(1'b0), .S(pc_plus_imm), .Cout(err)); // adds immediate number to PC

    mux2_1 pc_jump_sel [15:0] (.InA(pc_add), .InB(pc_plus_imm), .S(JUMP | (BRANCH & branch_mux)), .Out(pc_two_or_jump)); // picks PC + 2 or
                                                                                                           // PC + 2 + immediate

    mux2_1 pc_jr_sel [15:0] (.InA(pc_two_or_jump), .InB(alu_out), .S(JR), .Out(pc_next)); // picks result of last mux or
                                                                                                // result of ALU

    mux4_1 comp_choose (.InA(Zero), .InB(LT), .InC(Zero | LT), .InD(Cout), .S(COMP_TYPE), .Out(comparison_lsb)); // picks which comparison to make
    assign comparison = {15'b0, comparison_lsb};


endmodule
