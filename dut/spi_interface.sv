interface spi_if;

    logic write_en;
    logic clk;
    logic rst_n;
    logic [7:0] addr;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic done;
    logic error;

endinterface