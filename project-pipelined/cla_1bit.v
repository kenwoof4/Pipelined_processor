module cla_1bit(A, B, Cin, S, G, P);

input A, B, Cin;
output S, G, P;

assign G = A & B;
assign P = A ^ B;
assign S = P ^ Cin;

endmodule
