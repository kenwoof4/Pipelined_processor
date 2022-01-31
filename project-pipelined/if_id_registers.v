module if_id_registers(pc_add_in, instr_in, HALT_in, pc_add_out, instr_out, HALT_out, stall, jump_hazard, clk, rst);

    input [15:0] pc_add_in, instr_in;
    input HALT_in, stall, jump_hazard, clk, rst;
    output[15:0] pc_add_out, instr_out;
    output HALT_out;

    wire [15:0] nop_instr, instr_in_final;

    assign nop_instr = 16'h0800;

    mux2_1 instr_input_mux [15:0] (.InA(instr_in), .InB(nop_instr), .S(stall | jump_hazard), .Out(instr_in_final));

    dff if_id_pc_add [15:0] (.q(pc_add_out), .d(pc_add_in), .clk(clk), .rst(rst));
    dff if_id_instr [15:0] (.q(instr_out), .d(instr_in_final), .clk(clk), .rst(rst));
    dff if_id_HALT (.q(HALT_out), .d(HALT_in), .clk(clk), .rst(rst));

endmodule

