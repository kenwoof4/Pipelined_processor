module cla_4bit(A, B, Cin, S, G, P);

input [3:0] A, B;
input Cin;
output [3:0] S;
output G, P;
wire [2:0] carries;
wire G0, G1, G2, G3, P0, P1, P2, P3;

cla_1bit clas[3:0] (.A(A), .B(B), .Cin({carries, Cin}), .S(S), .G({G3, G2, G1, G0}), .P({P3, P2, P1, P0} ));

assign carries[0] 	= G0 | (P0 & Cin);
assign carries[1] 	= G1 | (P1 & G0) | (P1 & P0 & Cin);
assign carries[2] 	= G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin);
assign G 	= G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0);
assign P = P0 & P1 & P2 & P3;

endmodule
