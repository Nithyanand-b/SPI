interface spi_if(input logic clk, rst_n);
  // Master signals
  logic       master_start;
  logic [7:0] master_data_in;
  logic       master_busy;
  logic [7:0] master_data_out;

  // Slave signals
  logic [7:0] slave_data_in;
  logic [7:0] slave_data_out;

  // SPI signals
  logic       sclk;
  logic       mosi;
  logic       miso;
  logic       ss_n;

  modport master_port (
    input  clk, rst_n, miso,
    output sclk, mosi, ss_n,
    output master_start, master_data_in,
    input  master_busy, master_data_out
  );

  modport slave_port (
    input  clk, rst_n, sclk, mosi, ss_n, slave_data_in,
    output miso, slave_data_out
  );

  modport tb_port (
    input  clk, rst_n,
    input  master_busy, master_data_out, slave_data_out,
    output master_start, master_data_in, slave_data_in
  );
endinterface