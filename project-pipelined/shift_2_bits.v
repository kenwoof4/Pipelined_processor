module shift_2_bits (In, Shift, Op, Out);

input [15:0] In;
input Shift;
input [1:0]  Op;
output [15:0] Out;
wire [15:0] rotate_left, shift_left, rotate_right, shift_right, shifted;
wire[1:0] zero_mask;

assign zero_mask = 2'b0;
assign rotate_left = {In[13:0], In[15:14]};
assign shift_left = {In[13:0], zero_mask};
assign rotate_right = {In[1:0], In[15:2]};
assign shift_right = {zero_mask, In[15:2]};

mux4_1 opcode_mux[15:0] (.InA(rotate_left), .InB(shift_left), .InC(rotate_right), .InD(shift_right), .S(Op), .Out(shifted));
mux2_1 shift_mux[15:0] (.InA(In), .InB(shifted), .S(Shift), .Out(Out));

endmodule
