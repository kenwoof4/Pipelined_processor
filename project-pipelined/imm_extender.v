module imm_extender(out, to_extend, ZEXT, IMM_BITS);
    
    output [15:0] out;

    input [10:0] to_extend; // immediate number to extend
    input ZEXT; // whether to zero extend
    input [1:0] IMM_BITS; // number of bits to keep from the immediate (5, 8, or 11)
    
    wire [15:0] five_zext, eight_zext, eleven_zext, five_sext, eight_sext, eleven_sext;
    wire [15:0] five_or_eight_zext, final_zext, five_or_eight_sext, final_sext;
    wire [10:0] five_sext_msb;
    wire [7:0] eight_sext_msb;
    wire [4:0] eleven_sext_msb;

    assign five_zext = {11'b0, to_extend[4:0]};
    assign eight_zext = {8'b0, to_extend[7:0]};
    assign eleven_zext = {5'b0, to_extend};

    assign five_sext_msb = to_extend[4] ? 11'h7FF : 11'b0;
    assign eight_sext_msb = to_extend[7] ? 8'hFF : 8'b0;
    assign eleven_sext_msb = to_extend[10] ? 5'h1F : 5'b0;

    assign five_sext = {five_sext_msb, to_extend[4:0]};
    assign eight_sext = {eight_sext_msb, to_extend[7:0]};
    assign eleven_sext = {eleven_sext_msb, to_extend};

    mux2_1 five_or_eight_zext_mux [15:0] (.InA(five_zext), .InB(eight_zext), .S(IMM_BITS[0]), .Out(five_or_eight_zext));
    mux2_1 final_zext_mux [15:0](.InA(five_or_eight_zext), .InB(eleven_zext), .S(IMM_BITS[1]), .Out(final_zext));

    mux2_1 five_or_eight_sext_mux [15:0] (.InA(five_sext), .InB(eight_sext), .S(IMM_BITS[0]), .Out(five_or_eight_sext));
    mux2_1 final_sext_mux [15:0] (.InA(five_or_eight_sext), .InB(eleven_sext), .S(IMM_BITS[1]), .Out(final_sext));

    mux2_1 zext_or_sext_mux [15:0] (.InA(final_sext), .InB(final_zext), .S(ZEXT), .Out(out));

endmodule

