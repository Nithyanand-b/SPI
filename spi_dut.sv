module spi_dut (
  
  input  logic clk,
  input  logic rst_n,

  input        master_start,
  output       master_busy,

  // Master parallel interface

  input  [7:0] master_data_in,
  output [7:0] master_data_out,
  // Slave parallel interface
  input  [7:0] slave_data_in,
  output [7:0] slave_data_out
);

  // Internal SPI signals
  wire sclk;
  wire mosi;
  wire miso;
  wire ss_n;

  // Master instance
  spi_master master (
    .clk            (clk),
    .rst_n          (rst_n),
    .master_start   (master_start),
    .master_data_in (master_data_in),
    .master_busy    (master_busy),
    .master_data_out(master_data_out),
    .sclk           (sclk),
    .mosi           (mosi),
    .miso           (miso),
    .ss_n           (ss_n)
  );

  // Slave instance
  spi_slave slave (
    .clk           (clk),
    .rst_n         (rst_n),
    .slave_data_in (slave_data_in),
    .slave_data_out(slave_data_out),
    .sclk          (sclk),
    .mosi          (mosi),
    .miso          (miso),
    .ss_n          (ss_n)
  );

endmodule
