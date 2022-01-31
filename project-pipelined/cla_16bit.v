module cla_16bit(A, B, Cin, S, Cout);

input [15:0] A, B;
input Cin;
output [15:0] S;
output Cout;
wire [2:0] carries;
wire G0, G1, G2, G3, P0, P1, P2, P3, G, P;

cla_4bit clas[3:0] (.A(A), .B(B), .Cin({carries, Cin}), .S(S), .P({P3, P2, P1, P0}), .G({G3, G2, G1, G0}));

assign carries[0] 	= G0 | (P0 & Cin);
assign carries[1] 	= G1 | (P1 & G0) | (P1 & P0 & Cin);
assign carries[2] 	= G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin);
assign G 	= G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0);
assign P = P0 & P1 & P2 & P3;
assign Cout = G | (P & Cin);

endmodule
