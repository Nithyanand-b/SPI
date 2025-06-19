`include "uvm_macros.svh"
  import uvm_pkg::*;
`include "spi_if.sv"
`include "spi_master.sv"
`include "spi_slave.sv"
`include "spi_dut.sv"
`include "spi_sequence_item.sv"
`include "spi_sequence.sv"
`include "spi_sequencer.sv"
`include "spi_driver.sv"
`include "spi_monitor.sv"
`include "spi_agent.sv"
`include "spi_scoreboard.sv"
`include "spi_env.sv"
`include "spi_test.sv"


`timescale 1ns/1ps

module spi_top;
  import uvm_pkg::*;
  
  logic clk;
  logic rst_n;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  // Instantiate interface
  spi_if intf(.clk(clk), .rst_n(rst_n));

  // Instantiate DUT
  spi_dut dut (
    .clk            (clk),
    .rst_n          (rst_n),
    .master_start   (intf.master_start),
    .master_data_in (intf.master_data_in),
    .master_busy    (intf.master_busy),
    .master_data_out(intf.master_data_out),
    .slave_data_in  (intf.slave_data_in),
    .slave_data_out (intf.slave_data_out)
  );

  // Connect DUT to interface
  assign intf.sclk = dut.sclk;
  assign intf.mosi = dut.mosi;
  assign dut.miso  = intf.miso;
  assign intf.ss_n = dut.ss_n;

  // UVM start
  initial begin
    uvm_config_db#(virtual spi_if.tb_port)::set(null, "uvm_test_top.env.agent*", "vif", intf);
    run_test("spi_test");
  end

  // Simulation stop
  initial begin
    #2000;
    $display("Simulation finished");
    $finish;
  end
endmodule