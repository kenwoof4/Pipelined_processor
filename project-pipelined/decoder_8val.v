module decoder_8val (in, select_vector);

    input [2:0] in;
    output [7:0] select_vector;

    wire bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7;

    assign bit0 = ~in[0] & ~in[1] & ~in[2]; // 000
    assign bit1 = in[0] & ~in[1] & ~in[2]; // 001
    assign bit2 = ~in[0] & in[1] & ~in[2]; // 010
    assign bit3 = in[0] & in[1] & ~in[2]; // 011
    assign bit4 = ~in[0] & ~in[1] & in[2]; // 100
    assign bit5 = in[0] & ~in[1] & in[2]; // 101
    assign bit6 = ~in[0] & in[1] & in[2];// 110
    assign bit7 = in[0] & in[1] & in[2];// 111

    assign select_vector = {bit7, bit6, bit5, bit4, bit3, bit2, bit1, bit0};

endmodule

