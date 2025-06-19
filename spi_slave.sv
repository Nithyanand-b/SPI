module spi_slave (
  input  logic clk,   // system clock (for reset only)
  input  logic rst_n,
  input  logic [7:0] slave_data_in,
  output logic [7:0] slave_data_out,
  input  logic sclk,  // SPI clock
  input  logic mosi,  // SPI data in
  output logic miso,  // SPI data out
  input  logic ss_n   // Slave select (active low)
);

  logic [7:0] tx_reg;
  logic [7:0] rx_reg;
  logic [2:0] bit_count;
  logic prev_sclk;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      prev_sclk <= 0;
      tx_reg <= 0;
      rx_reg <= 0;
      bit_count <= 0;
      slave_data_out <= 0;
      miso <= 0;
    end
    else begin
      prev_sclk <= sclk;
      
      // Load new data when SS_n goes high
      if (ss_n) begin
        tx_reg <= slave_data_in;
        bit_count <= 0;
      end
      // Capture MOSI on rising edge of SCLK when SS_n is low
      else if (!prev_sclk && sclk) begin
        rx_reg <= {rx_reg[6:0], mosi};
        if (bit_count == 7) begin
          slave_data_out <= {rx_reg[6:0], mosi};
        end
        bit_count <= bit_count + 1;
      end
      
      // Change MISO on falling edge of SCLK when SS_n is low
      if (prev_sclk && !sclk && !ss_n) begin
        miso <= tx_reg[7];
        tx_reg <= {tx_reg[6:0], 1'b0};
      end
    end
  end
endmodule