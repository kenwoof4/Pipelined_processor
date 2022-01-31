module hazard_detection (JUMP_ex, BRANCH_ex, JUMP_id, BRANCH_id, HALT_id, HALT_ex, HALT_mem, HALT_wb, jump_hazard, stall);

    input JUMP_ex, JUMP_id, BRANCH_ex, BRANCH_id, HALT_id, HALT_ex, HALT_mem, HALT_wb;
    output jump_hazard, stall;

    assign jump_hazard = JUMP_ex | BRANCH_ex;
    assign stall = (JUMP_id | BRANCH_id | HALT_id | HALT_ex | HALT_mem) & ~HALT_wb;

endmodule

