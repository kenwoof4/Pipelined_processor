module shifter (In, Cnt, Op, Out);

   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   wire[15:0] shift_8, shift_4, shift_2;

   shift_8_bits SHIFT_8(.In(In), .Shift(Cnt[3]), .Op(Op), .Out(shift_8));
   shift_4_bits SHIFT_4(.In(shift_8), .Shift(Cnt[2]), .Op(Op), .Out(shift_4));
   shift_2_bits SHIFT_2(.In(shift_4), .Shift(Cnt[1]), .Op(Op), .Out(shift_2));
   shift_1_bit SHIFT_1(.In(shift_2), .Shift(Cnt[0]), .Op(Op), .Out(Out));

endmodule
