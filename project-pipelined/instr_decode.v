module instr_decode(instruction, to_write, write_register_in, REG_WRITE_in, id_HALT, clk, rst, IMM_USE, BRANCH, BRANCH_CHOOSE, 
         COMP_REG, COMP_TYPE, JUMP, JR, LBI, SLBI, MEM_READ, MEM_WRITE, ALUop, read_data_1, read_data_2, immediate,
         write_register_out, REG_WRITE_out, err);

    input [15:0] instruction;
    input [15:0] to_write; // data from write back stage to write
    input [2:0] write_register_in;
    input REG_WRITE_in;
    input id_HALT;
    input clk; // clock signal
    input rst; // reset signal

    output IMM_USE; // whether an immediate is used in the alu
    output BRANCH; // whether a branch might be taken
    output [1:0] BRANCH_CHOOSE; // which branch to take if a branch is taken
    output COMP_REG; // whether the instruction was a compare registers instruction
    output [1:0] COMP_TYPE; // what type of compare should be done between registers
    output JUMP; // whether the instruction will jump
    output JR; // whether the instruction is jr
    output LBI; // if the instruction was LBI
    output SLBI; // if the instruction was SLBI
    output MEM_READ; // whether to read a value from memory
    output MEM_WRITE; // whether to write a value to memory

    output [3:0] ALUop; // alu opcode 
    output [15:0] read_data_1; // data read from first register
    output [15:0] read_data_2; // data read from second register;
    output [15:0] immediate;
    output [2:0] write_register_out;
    output REG_WRITE_out;
    output err;

    wire [1:0] IMM_BITS; // how many bits should be included in the immediate
    wire WRITE_DEST; // which part of the instruction should be used to identify the write register
    wire ZEXT; // whether the immediate value should be zero extended (if not then sign extended)
    wire STU; // if the instruction was STU
    wire[2:0] which_instr, instr_lbi;

    control_signals control_signals (.opcode(instruction[15:11]), .last_bits(instruction[1:0]), .id_HALT(id_HALT),
            .rst(rst), .err(err), .IMM_USE(IMM_USE), .BRANCH(BRANCH), .BRANCH_CHOOSE(BRANCH_CHOOSE), .WRITE_DEST(WRITE_DEST), 
            .REG_WRITE(REG_WRITE_out), .COMP_REG(COMP_REG), .COMP_TYPE(COMP_TYPE), .ZEXT(ZEXT), .JUMP(JUMP), .JR(JR),
            .LBI(LBI), .SLBI(SLBI), .STU(STU), .MEM_READ(MEM_READ), .MEM_WRITE(MEM_WRITE), .IMM_BITS(IMM_BITS),
            .NOP(NOP), .ALUop(ALUop));
    
    imm_extender imm_extender (.out(immediate), .to_extend(instruction[10:0]), .ZEXT(ZEXT), .IMM_BITS(IMM_BITS));

    register_wrapper registers (.read1data(read_data_1), .read2data(read_data_2), .err(err), .clk(clk), .rst(rst), 
                .read1regsel(instruction[10:8]), .read2regsel(instruction[7:5]), .writeregsel(write_register_in), 
                .writedata(to_write), .write(REG_WRITE_in));

    
    mux2_1 which_instr_mux[2:0] (.InA(instruction[7:5]), .InB(instruction[4:2]), .S(WRITE_DEST), .Out(which_instr));
    mux2_1 instr_lbi_mux [2:0](.InA(which_instr), .InB(instruction[10:8]), .S(LBI | SLBI | STU), .Out(instr_lbi));
    mux2_1 write_register_mux [2:0] (.InA(instr_lbi), .InB(3'h7), .S(JUMP), .Out(write_register_out));

endmodule

