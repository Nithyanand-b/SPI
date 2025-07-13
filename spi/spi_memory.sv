module spi_memory (

  input clk,
  input reset,
  input cs,
  input miso,

  output reg ready, op_done, mosi

);
  
  reg [7:0] mem [31:0];
  integer count = 0;
  reg [15:0] d_in;
  reg [7:0] d_out;

  typedef enum logic [2:0] { 
                           idle = 0,
                           detect = 1,
                           store = 2,
                           read_addr = 3,
                           send_data = 4  } state_type;

  state_type state = idle;

  always @(posedge clk) begin

    if (reset) begin
      state <= idle;
      count <= 0;
      mosi <= 0;
      ready <= 0;
      op_done <= 0;
    end

    else begin
      case (state)
        idle: begin
          count <= 0;
          mosi <= 0;
          ready <= 0;
          op_done <= 0;
          d_in <= 0;

            if(!cs) 
              state <= detect;
            else 
              state <= idle;
        end

        detect:begin
          if(miso)
            state <= store;
          else
            state <= read_addr;
        end

        store:begin
          if (count <= 15) begin
            d_in[count] <= miso;
            count <= count + 1;
            state <= store;
          end
          else
          begin
            mem[d_in[7:0]] <= d_in[15:8];
            state <= idle;
            count <= 0;
            op_done <= 1'b1;
          end
        end

        read_addr: begin
          if (count <= 7) begin
            count <= count + 1;
            d_in[count] <= miso;
            state <= read_addr;
          end
          else begin
            count <= 0;
            state <= send_data;
            ready <= 1'b1;
            d_out <= mem[d_in];
          end
        end

        send_data:begin
          ready <= 1'b0;
          if (count < 8) begin
            count <= count + 1;
            mosi <= d_out[count];
            state <= send_data;
          end
        end

        default: state <= idle;
      endcase
    end
  end

endmodule