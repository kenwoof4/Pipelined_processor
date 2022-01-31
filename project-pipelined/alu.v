module alu (Out, Zero, Neg, Cout, A, B, Cin, ALUop);

  input [15:0] A; // input A
  input [15:0] B; // input B
  input Cin; // Carry in
  input [3:0] ALUop; // alu opcode

  output [15:0] Out; // sum or shift
  output Cout; // overflow flag
  output Zero; // zero flag
  output Neg; // negative flag

  wire [15:0] A_not, B_not, A_or_B, A_xor_B, A_and_B, A_bit_rev, sum, shifted, out_temp, out_shift;
  wire is_addition, is_subtraction, zero_temp, neg_temp;

    assign is_addition = ~(|ALUop);
    assign is_subtraction = ~(|ALUop[3:1]) & ALUop[0];

  assign A_or_B = A | B;
  assign A_xor_B = A ^ B;
  assign A_and_B = A & B;
  assign A_bit_rev = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]};

  cla_16bit adder(.A(A), .B(B), .Cin(Cin), .S(sum), .Cout(Cout));

  assign zero_temp = ~(|sum);
  assign Zero = zero_temp & (is_addition | is_subtraction);
  assign pos_Ofl = ~A[15] & ~B[15] & sum[15];
  assign neg_Ofl = (A[15] & B[15] & ~sum[15]);
  assign neg_temp = sum[15] ? (pos_Ofl ? 1'b0 : 1'b1) : (neg_Ofl ? 1'b1 : 1'b0);
  assign Neg = neg_temp & (is_subtraction | is_addition);


  shifter shift(.In(A), .Cnt(B[3:0]), .Op(ALUop[1:0]), .Out(shifted));

  mux4_1 out_temp_mux [15:0] (.InA(sum), .InB(sum), .InC(A_xor_B), .InD(A_and_B), .S(ALUop[1:0]), .Out(out_temp));
  mux2_1 out_shift_mux  [15:0](.InA(out_temp), .InB(shifted), .S(ALUop[2]), .Out(out_shift));
  mux2_1 final_out[15:0] (.InA(out_shift), .InB(A_bit_rev), .S(ALUop[3]), .Out(Out));


endmodule
