module mux4_1(InA,InB,InC,InD,S,Out);
input InA, InB, InC, InD;
input [1:0] S;
output Out;
wire AorB, CorD;

mux2_1 mux2_1(.InA(InA), .InB(InB), .S(S[0]), .Out(AorB));
mux2_1 mux2_2(.InA(InC), .InB(InD), .S(S[0]), .Out(CorD));
mux2_1 mux2_3(.InA(AorB), .InB(CorD), .S(S[1]), .Out(Out));
endmodule
