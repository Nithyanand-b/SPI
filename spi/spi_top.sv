`include "spi_controller.sv"
`include "spi_memory.sv"

module top (

  input clk,
  input reset,

  input wr,
  input [7:0] addr,
  input [7:0] data_in,

  output [7:0] data_out,
  output done,  
  output error

);

wire mosi, cs, ready, op_done, miso;

spi_controller spi_control(
                            
                           //input
                           .clk(clk), 
                           .reset(reset), 
                           .wr(wr),  
                           .addr(addr), 
                           .data_in(data_in), 

                           .mosi(mosi), 
                           .cs(cs), 
                           
                           .ready(ready),
                           .op_done(op_done), 
                           .miso(miso), 
                          
                           //output 
                           .data_out(data_out), 
                           .done(done),
                           .error(error)

                           );

spi_memory spi_mem(
                   
                          //input
                          .mosi(mosi),
                          .cs(cs),
                          .clk(clk),
                          .reset(reset),
      
                          //output
                          .ready(ready),
                          .op_done(op_done),
                          .miso(miso)
      
                          );
  
endmodule