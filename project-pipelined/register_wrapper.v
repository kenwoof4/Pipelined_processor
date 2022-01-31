module register_wrapper (
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

   wire read1_write_match, read2_write_match;
   wire [15:0] read1temp, read2temp;

   assign read1_write_match = &(read1regsel ^~ writeregsel) & write;
   assign read2_write_match = &(read2regsel ^~ writeregsel) & write;

   rf registers (.read1data(read1temp), .read2data(read2temp), .err(err), .clk(clk), .rst(rst),
                .read1regsel(read1regsel), .read2regsel(read2regsel), .writeregsel(writeregsel),
                .writedata(writedata), .write(write));
   
   mux2_1 read1mux [15:0] (.InA(read1temp), .InB(writedata), .S(read1_write_match), .Out(read1data));
   mux2_1 read2mux [15:0] (.InA(read2temp), .InB(writedata), .S(read2_write_match), .Out(read2data));

endmodule
