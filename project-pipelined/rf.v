/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

   assign err = 1'b0;

   wire [7:0] write_sel;
   wire [15:0] current_0, current_1, current_2, current_3, current_4, current_5, current_6, current_7,
         to_write_0, to_write_1, to_write_2, to_write_3, to_write_4, to_write_5, to_write_6, to_write_7;

   decoder_8val write_register (.in(writeregsel), .select_vector(write_sel));

   mux2_1 reg_0_write [15:0] (.InA(current_0), .InB(writedata), .S(write_sel[0] & write), .Out(to_write_0));
   mux2_1 reg_1_write [15:0] (.InA(current_1), .InB(writedata), .S(write_sel[1] & write), .Out(to_write_1));
   mux2_1 reg_2_write [15:0] (.InA(current_2), .InB(writedata), .S(write_sel[2] & write), .Out(to_write_2));
   mux2_1 reg_3_write [15:0] (.InA(current_3), .InB(writedata), .S(write_sel[3] & write), .Out(to_write_3));
   mux2_1 reg_4_write [15:0] (.InA(current_4), .InB(writedata), .S(write_sel[4] & write), .Out(to_write_4));
   mux2_1 reg_5_write [15:0] (.InA(current_5), .InB(writedata), .S(write_sel[5] & write), .Out(to_write_5));
   mux2_1 reg_6_write [15:0] (.InA(current_6), .InB(writedata), .S(write_sel[6] & write), .Out(to_write_6));
   mux2_1 reg_7_write [15:0] (.InA(current_7), .InB(writedata), .S(write_sel[7] & write), .Out(to_write_7));

   register registers [7:0] (.clk(clk), .rst(rst), .in({to_write_7, to_write_6, to_write_5, to_write_4, to_write_3,
        to_write_2, to_write_1, to_write_0}), .out({current_7, current_6, current_5, current_4, current_3,
        current_2, current_1, current_0}));
   
   mux8_1 read1_sel [15:0] (.InA(current_0), .InB(current_1), .InC(current_2), .InD(current_3), .InE(current_4),
        .InF(current_5), .InG(current_6), .InH(current_7), .Sel(read1regsel), .Out(read1data));

   mux8_1 read2_sel [15:0] (.InA(current_0), .InB(current_1), .InC(current_2), .InD(current_3), .InE(current_4),
        .InF(current_5), .InG(current_6), .InH(current_7), .Sel(read2regsel), .Out(read2data));


endmodule
// DUMMY LINE FOR REV CONTROL :1:
