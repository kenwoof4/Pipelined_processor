module mux8_1(InA, InB, InC, InD, InE, InF, InG, InH, Sel, Out);
    
    input InA, InB, InC, InD, InE, InF, InG, InH;
    input [2:0] Sel;
    output Out;

    wire AorB, CorD, EorF, GorH, ABCD, EFGH;

    assign AorB = (InA & ~(Sel[0])) | (InB & Sel[0]);
    assign CorD = (InC & ~(Sel [0])) | (InD & Sel[0]);
    assign EorF = (InE & ~(Sel[0])) | (InF & Sel[0]);
    assign GorH = (InG & ~(Sel[0])) | (InH & Sel[0]);

    assign ABCD = (AorB & ~(Sel[1])) | (CorD & Sel[1]);
    assign EFGH = (EorF & ~(Sel[1])) | (GorH & Sel[1]);

    assign Out = (ABCD & ~Sel[2]) | (EFGH & Sel[2]);

endmodule

