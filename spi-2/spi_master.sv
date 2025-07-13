module spi_master (
  input        mclk,
  input        reset,
  input        load,
  input        read,
  input        miso,
  input        start,
  input  [7:0] data_in,
  output [7:0] data_out,
  output reg   mosi,
  output reg   cs,
  output       sclk
);

  int          count;
  reg  [7:0]   shift_reg;
  reg  [7:0]   data_out_reg;

  assign data_out = (read) ? data_out_reg : 8'h00;
  assign sclk     = mclk;

  always @(posedge sclk or negedge reset) begin
    if (!reset) begin
      shift_reg    <= 8'h00;
      data_out_reg <= 8'h00;
      mosi         <= 1'b0;
      cs           <= 1'b0;
      count        <= 0;
    end 
    else if (start) begin
      if (load) begin
        shift_reg <= data_in;
        count     <= 0;
      end 
      else if (read) begin
        data_out_reg <= shift_reg;
      end 
      else if (count < 8) begin
        shift_reg <= {miso, shift_reg[7:1]};
        mosi      <= shift_reg[0];
        count     <= count + 1;
      end
    end
  end

endmodule