module control_signals(opcode, last_bits, id_HALT, rst, err, IMM_USE, BRANCH, BRANCH_CHOOSE, WRITE_DEST, REG_WRITE, 
        COMP_REG, COMP_TYPE, ZEXT, JUMP, JR, LBI, SLBI, STU, MEM_READ, MEM_WRITE, IMM_BITS, NOP, ALUop);
    
    input [4:0] opcode; // instruction opcode
    input [1:0] last_bits; // last 2 bits of instruction
    input id_HALT;
    input rst;
    input err; // if there was an error somewhere

    output IMM_USE; // whether an immediate is used in the alu
    output BRANCH; // whether a branch might be taken
    output [1:0] BRANCH_CHOOSE; // which branch to take if a branch is taken
    output WRITE_DEST; // which part of the instruction should be used to identify the write register
    output REG_WRITE; // whether to write to a register
    output COMP_REG; // whether the instruction was a compare registers instruction
    output [1:0] COMP_TYPE; // what type of compare should be done between registers
    output ZEXT; // whether the immediate value should be zero extended (if not then sign extended)
    output JUMP; // whether the instruction will jump
    output JR; //whether the instruction is JR
    output LBI; // if the instruction was LBI
    output SLBI; // if the instruction was SLBI
    output STU; // if the instruction was STU
    output MEM_READ; // whether to read a value from memory
    output MEM_WRITE; // whether to write a value to memory
    output [1:0] IMM_BITS; // how many bits should be included in the immediate
    output NOP; // if NOP is asserted
    output [3:0] ALUop; // alu opcode

    wire reg_write_temp, mem_write_temp, jump_temp, branch_temp, jr_temp;


    assign NOP = (~(|opcode[4:1]) & opcode[0]);
    assign IMM_USE = ~opcode[4] | (opcode[4] & ~opcode[3]);
    assign branch_temp = ~opcode[4] & opcode[3] & opcode[2];
    assign BRANCH_CHOOSE = opcode[1:0];
    assign WRITE_DEST = opcode[4] & opcode[3];
    assign reg_write_temp = (opcode[4] & (|opcode[3:0])) | (~opcode[4] & ~opcode[3] & opcode[2] & opcode[1]) |
            (~opcode[4] & opcode[3] & ~opcode[2]);
    assign COMP_REG = opcode[4] & opcode[3] & opcode[2];
    assign COMP_TYPE = opcode[1:0];
    assign LBI = opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
    assign SLBI = opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0];
    assign STU = opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & opcode[0];
    assign ZEXT = SLBI | (~opcode[4] & opcode[3] & ~opcode[2] & opcode[1]);
    assign jump_temp = ~opcode[4] & ~opcode[3] & opcode[2];
    assign jr_temp = JUMP & opcode[0];
    assign MEM_READ = opcode[4] & opcode[0] & ~(|opcode[3:1]);
    assign mem_write_temp = opcode[4] & ~opcode[3] & ~opcode[2] & (opcode[1] ^~ opcode[0]);
    assign IMM_BITS[1] = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[0];
    assign IMM_BITS[0] = (~opcode[4] & opcode[3] & opcode[2]) | LBI | SLBI | (~opcode[4] & ~opcode[3] & opcode[2] & opcode[0]);

    assign ALUop[3] = opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0];
    assign ALUop[2] = (opcode[4] & ~opcode[3] & opcode[2]) | (opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0]) | SLBI;
    assign ALUop[1] = (~opcode[4] & opcode[3] & ~opcode[2] & opcode[1]) | 
            (opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & opcode[0] & last_bits[1]) |
            (opcode[4] & ~opcode[3] & opcode[2] & opcode[1]) |
            (opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0] & last_bits[1]);
    assign ALUop[0] = (opcode[4] & ~opcode[3] & opcode[2] & opcode[0]) | SLBI |
            (~opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & opcode[0]) |
            (opcode[4] & opcode[3] & ~opcode[2] & opcode[1] & last_bits[0]) |
            (~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & opcode[0]) |
            (opcode[4] & opcode[3] & opcode[2] & ~(&opcode[1:0]));

    mux2_1 reg_write_mux (.InA(reg_write_temp), .InB(1'b0), .S(id_HALT | NOP), .Out(REG_WRITE));
    mux2_1 mem_write_mux (.InA(mem_write_temp), .InB(1'b0), .S(id_HALT | NOP), .Out(MEM_WRITE));
    mux2_1 jump_mux (.InA(jump_temp), .InB(1'b0), .S(id_HALT | NOP), .Out(JUMP));
    mux2_1 branch_mux (.InA(branch_temp), .InB(1'b0), .S(id_HALT | NOP), .Out(BRANCH));
    mux2_1 jr_mux (.InA(jr_temp), .InB(1'b0), .S(id_HALT | NOP), .Out(JR));

endmodule


