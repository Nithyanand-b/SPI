`include"spi_controller.sv"
`include"spi_memory.sv"

module dut(
    input write_en, clk, rst_n,
    input [7:0] addr, data_in,
    output [7:0] data_out,
    output done, error
);

wire cs_n, mosi, miso, ready, op_done;

spi_controller controller_inst (
    .write_en(write_en),
    .clk(clk),
    .rst_n(rst_n),
    .ready(ready),
    .op_done(op_done),
    .addr(addr),
    .data_in(data_in),
    .data_out(data_out),
    .cs_n(cs_n),
    .mosi(mosi),
    .miso(miso),
    .done(done),
    .error(error)
);

spi_memory memory_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cs_n(cs_n),
    .miso(mosi),  // Controller's MOSI is Memory's MISO
    .ready(ready),
    .mosi(miso),   // Memory's MOSI is Controller's MISO
    .op_done(op_done)
);

endmodule