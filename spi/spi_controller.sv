module spi_controller (


  input clk, reset, wr,
  input [7:0] data_in, addr, 

  input ready, op_done, miso,

  output reg cs, mosi,

  output [7:0] data_out,
  output reg done, error
);
  
  reg [16:0] din_reg;
  reg [7:0] dout_reg;

  integer count = 0;

  typedef enum logic [2:0]  {
                            idle = 0,
                            load = 1,
                            check_op = 2,
                            send_data = 3,
                            send_addr = 4,
                            read_data = 5,
                            error_state = 6,
                            check_ready = 7  } state_t; 

state_t state = idle;

  always @(posedge clk) begin
        if (reset) begin
          
          state <= idle;
          count <= 0;

          //active low
          cs <= 1'b1;

          mosi = 1'b0;
          error = 1'b0;
          done = 1'b0;
      
        end    

        else begin

          case (state)

            idle: begin
                    
                mosi = 1'b0;
                cs <= 1'b1;
                
                state <= load;
      
                error = 1'b0;
                done = 1'b0;
                
            end 

            load: begin

              din_reg <= {data_in,addr,wr};
              state <= check_op;

            end

            check_op: begin

              if (wr == 1'b1 && addr < 32) begin
                  cs <= 1'b0;
                  state <= send_data;
              end
//
              else if (wr == 1'b0 && addr < 32) begin
                state <= send_addr;
                cs <= 1'b0;
              end
//
              else begin
                state <= error_state;
                cs <= 1'b1;
              end

              end

            send_data: begin
              if (count <= 16) begin
                count <= count + 1;
                mosi <= din_reg[count];
                state <= send_data;
              end
              else begin
                cs <= 1'b1;
                mosi <= 1'b0;

                if(op_done) begin
                  count <= 0;
                  done <= 1'b1;
                  state <= idle;
                end 
                else begin
                  state <= send_data;
                end
              end
            end

              send_addr: begin
                if(count <= 8)
                begin
                  count <= count + 1;
                  cs <= 1'b1;
                  state <= send_addr;
                end

                else 
                begin
                  count <= 0;
                  cs <= 1'b1;
                  state <= check_ready;
                end

              end

                check_ready:begin
                  if(ready)
                  state <= read_data;
                  else
                  state <= check_ready;
                end

                 read_data:begin
                  if (count <= 7) begin
                    count <= count + 1;
                    dout_reg[count] <= miso;
                    state <= read_data;
                  end
                  else begin
                    count <= 0;
                    done <= 1'b1;
                    state <= idle;
                  end
                end

                error_state:begin
                  error <= 1'b1;
                  state <= idle;
                  done <= 1'b1;
              end

            default: begin
               state <= idle;
               count <= 0;
               done <= 0;
            end

          endcase
        end
  end

assign data_out = dout_reg;

endmodule  