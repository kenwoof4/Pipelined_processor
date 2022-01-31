module register(clk, rst, in, out);

    input clk, rst;
    input [15:0] in;
    output [15:0] out;

    dff dffs [0:15] (.q(out), .d(in), .clk(clk), .rst(rst));

endmodule
// DUMMY LINE FOR REV CONTROL
