interface spi_if(input logic clk, input logic rst_n);
    logic start;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic done;
    logic sclk;
    logic cs_n;
    logic mosi;
    logic miso;
endinterface