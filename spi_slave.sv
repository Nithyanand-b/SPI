module spi_slave (
  input        sclk,
  input        reset,
  input        cs,
  input        mosi,
  input        read,
  input        load,
  input  [7:0] data_in,
  output reg   miso,
  output [7:0] data_out
);

  int          count;
  reg  [7:0]   shift_reg;
  reg  [7:0]   data_out_reg;

  assign data_out = (read) ? data_out_reg : 8'h00;

  // Load data or latch data_out
  always @(posedge sclk) begin
    if (load) begin
      shift_reg <= data_in;
      count     <= 0;
    end 
    else if (read) begin
      data_out_reg <= shift_reg;
    end
  end

  // Shift data and drive MISO
  always @(negedge sclk or negedge cs) begin
    if (!reset) begin
      shift_reg    <= 8'h00;
      data_out_reg <= 8'h00;
      miso         <= 1'b0;
      count        <= 0;
    end 
    else if (!cs) begin
      if (!read && !load && (count <= 8)) begin
        shift_reg <= {mosi, shift_reg[7:1]};
        miso      <= shift_reg[0];
        count     <= count + 1;
      end
    end
  end

endmodule
