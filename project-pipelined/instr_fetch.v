module instr_fetch(pc_add, instr_next, HALT_out, err, clk, rst, pc_execute, HALT_in, stall, jump_hazard, JUMP_id, BRANCH_id,
        JUMP_ex, BRANCH_ex);

    output [15:0] pc_add; // current PC plus 2
    output [15:0] instr_next; // next instruction to execute
    output HALT_out;
    output err; // asserted if critical hardware error

    input clk; // clock signal
    input rst; // reset signal
    input [15:0] pc_execute; // address from execute stage that may or may not be next instruction
    input HALT_in; // if HALT was asserted
    input stall; // if a stall from the Hazard Detection Unit was asserted
    input jump_hazard; // if a jump hazard from the hazard detection unit was asserted
    input JUMP_id, BRANCH_id, JUMP_ex, BRANCH_ex;


    wire [15:0] pc_next, pc_next_temp, pc_current;

    dff PC[15:0] (.q(pc_current), .d(pc_next), .clk(clk), .rst(rst)); // PC register
    
    memory2c instr_mem (.data_out(instr_next), .data_in(16'b0), .addr(pc_current), .enable(1'b1), .wr(1'b0),
            .createdump(1'b0), .clk(clk), .rst(rst)); // Instruction memory
    
    
    cla_16bit pc_increment (.A(pc_current), .B(16'b10), .Cin(1'b0), .S(pc_add), .Cout(err)); // increments PC by 2


    mux2_1 which_stage_pc [15:0] (.InA(pc_add), .InB(pc_execute), .S(jump_hazard), .Out(pc_next_temp)); // pick between execute stage pc and fetch stage pc
    mux2_1 pc_sel_final [15:0] (.InA(pc_next_temp), .InB(pc_current), .S(HALT_in | stall), .Out(pc_next)); // pick between new pc value and current pc value

    assign HALT_out = ~(|instr_next[15:11]) & ~rst & ~(JUMP_id | BRANCH_id) & ~(JUMP_ex | BRANCH_ex);




endmodule

 