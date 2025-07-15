`include"spi_controller.sv"
`include"spi_memory.sv"

module dut(

    input clk,
    input rst_n,

    input write_en,
    input [7:0] addr,
    input [7:0] data_in,

    output [7:0] data_out,

    output done,
    output error

);

wire cs_n, mosi, miso, ready, op_done;

spi_controller controller_inst (

    .clk(clk),
    .rst_n(rst_n),

    .write_en(write_en),
    .addr(addr),
    .data_in(data_in),

    .mosi(mosi),
    .cs_n(cs_n),

    .ready(ready),
    .op_done(op_done),
    .miso(miso),

    .data_out(data_out),

    .done(done),
    .error(error)
);

spi_memory memory_inst (

    .clk(clk),
    .rst_n(rst_n),
    
    .mosi(miso),   // Memory's MOSI is Controller's MISO
    .miso(mosi),  // Controller's MOSI is Memory's MISO
    .ready(ready),

    .cs_n(cs_n),
    .op_done(op_done)
);

endmodule