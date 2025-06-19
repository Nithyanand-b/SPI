module spi_master (
  input  logic clk,
  input  logic rst_n,
  input  logic master_start,
  input  logic [7:0] master_data_in,
  output logic master_busy,
  output logic [7:0] master_data_out,
  output logic sclk,
  output logic mosi,
  input  logic miso,
  output logic ss_n
);

  typedef enum {IDLE, RUN} state_t;
  state_t state;

  logic [2:0] bit_count;
  logic [7:0] tx_reg;
  logic [7:0] rx_reg;
  logic [1:0] clk_div;
  logic sclk_int;

  // Generate SPI clock (1/4 system clock)
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      clk_div <= 0;
      sclk_int <= 0;
    end
    else if (state == RUN) begin
      clk_div <= clk_div + 1;
      if (clk_div == 1) sclk_int <= 1;
      if (clk_div == 3) sclk_int <= 0;
    end
    else begin
      clk_div <= 0;
      sclk_int <= 0;
    end
  end

  assign sclk = sclk_int;

  // FSM
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state         <= IDLE;
      master_busy   <= 0;
      ss_n          <= 1;
      mosi          <= 0;
      master_data_out <= 0;
      tx_reg        <= 0;
      rx_reg        <= 0;
      bit_count     <= 0;
    end else begin
      case (state)
        IDLE: begin
          ss_n        <= 1;
          master_busy <= 0;
          if (master_start) begin
            state       <= RUN;
            master_busy <= 1;
            ss_n        <= 0;
            tx_reg      <= master_data_in;
            bit_count   <= 0;
            rx_reg      <= 0;
          end
        end

        RUN: begin
          ss_n <= 0;  // Keep SS_n low during transfer
          
          // MOSI changes on falling edge (clk_div==3)
          if (clk_div == 3) begin
            mosi <= tx_reg[7];
            tx_reg <= {tx_reg[6:0], 1'b0};
          end
          
          // MISO capture on rising edge (clk_div==1)
          if (clk_div == 1) begin
            rx_reg <= {rx_reg[6:0], miso};
            if (bit_count == 7) begin
              state <= IDLE;
              master_data_out <= {rx_reg[6:0], miso};  // Capture final bit
              master_busy <= 0;
            end
            bit_count <= bit_count + 1;
          end
        end
      endcase
    end
  end
endmodule