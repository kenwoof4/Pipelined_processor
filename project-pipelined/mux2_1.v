module mux2_1(InA,InB,S,Out);
input InA, InB, S;
output Out;
wire Snot, IsA, IsB;

not1 not1_1(.in1(S), .out(Snot));
nand2 nand2_1(.in1(InA), .in2(Snot), .out(IsA));
nand2 nand2_2(.in1(InB), .in2(S), .out(IsB));
nand2 nand2_3(.in1(IsA), .in2(IsB), .out(Out));
endmodule
