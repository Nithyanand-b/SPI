module spi_dut(
    input  logic clk, rst_n,
    input  logic start,
    input  logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic done
);
    logic sclk, cs_n, mosi, miso;
    
    spi_master #(.DIVIDER(5)) u_master (
        .clk(clk), .rst_n(rst_n),
        .start(start), .data_in(data_in), .data_out(data_out), .done(done),
        .sclk(sclk), .cs_n(cs_n), .mosi(mosi), .miso(miso)
    );
    
    spi_slave u_slave (
        .sclk(sclk), .cs_n(cs_n), .mosi(mosi), .miso(miso)
    );
endmodule