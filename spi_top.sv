import uvm_pkg::*;
`include "uvm_macros.svh"

`include "spi_interface.sv"
`include "spi_dut.sv"
`include "spi_master.sv"
`include "spi_slave.sv"
`include "spi_sequence_item.sv"
`include "spi_sequence.sv"
`include "spi_sequencer.sv"
`include "spi_driver.sv"
`include "spi_monitor.sv"
`include "spi_agent.sv"
`include "spi_scoreboard.sv"
`include "spi_env.sv"
`include "spi_test.sv"

module spi_top;

  //---------------------------------------
  // Clock and reset signal declaration
  //---------------------------------------
  bit clk;
  bit reset;

  //---------------------------------------
  // Clock generation
  //---------------------------------------
  always #5 clk = ~clk;

  //---------------------------------------
  // Reset generation
  //---------------------------------------
  initial begin
    reset = 0;
    #5 reset = 1;
  end

  //---------------------------------------
  // Interface instance
  //---------------------------------------
  spi_interface intf (clk, reset);

  //---------------------------------------
  // DUT instance
  //---------------------------------------
  top_dut dut (
    .mclk            (intf.mclk),
    .reset           (intf.reset),
    .load_master     (intf.load_master),
    .load_slave      (intf.load_slave),
    .read_master     (intf.read_master),
    .read_slave      (intf.read_slave),
    .start           (intf.start),
    .data_in_master  (intf.data_in_master),
    .data_in_slave   (intf.data_in_slave),
    .data_out_master (intf.data_out_master),
    .data_out_slave  (intf.data_out_slave)
  );

  //---------------------------------------
  // UVM config and wave dump
  //---------------------------------------
  initial begin
    uvm_config_db#(virtual spi_interface)::set(uvm_root::get(), "*", "vif", intf);
    // enable wave dump here if needed
  end

  //---------------------------------------
  // Run the test
  //---------------------------------------
  initial begin
    run_test("spi_test");
  end

endmodule
