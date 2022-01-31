module memory(read_data, err, addr, write_data, MEM_WRITE, MEM_READ, clk, rst, HALT);

    input [15:0] addr; // address to read/write
    input [15:0] write_data; // data to write
    input MEM_WRITE; // whether to write to memory
    input MEM_READ; // whether to read memory
    input clk; // system clock
    input rst; // system reset signal
    input HALT; // if HALT instruction

    output [15:0] read_data; // data that was read
    output err; // asserted if hardware error


    assign err = MEM_WRITE & MEM_READ; // assert error if mem_write and mem_read are asserted

    memory2c data_mem (.data_out(read_data), .data_in(write_data), .addr(addr), .enable(MEM_WRITE | MEM_READ),
            .wr(MEM_WRITE), .createdump(HALT), .clk(clk), .rst(rst));
    

endmodule

