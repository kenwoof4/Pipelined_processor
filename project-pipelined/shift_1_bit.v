module shift_1_bit (In, Shift, Op, Out);

input [15:0] In;
input Shift;
input [1:0]  Op;
output [15:0] Out;
wire [15:0] rotate_left, shift_left, rotate_right, shift_right, shifted;

assign rotate_left = {In[14:0], In[15]};
assign shift_left = {In[14:0], 1'b0};
assign rotate_right = {In[0], In[15:1]};
assign shift_right = {1'b0, In[15:1]};

mux4_1 opcode_mux[15:0] (.InA(rotate_left), .InB(shift_left), .InC(rotate_right), .InD(shift_right), .S(Op), .Out(shifted));
mux2_1 shift_mux[15:0] (.InA(In), .InB(shifted), .S(Shift), .Out(Out));

endmodule
