`timescale 1ns / 1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "spi_interface.sv"
`include "dut.sv"
`include "spi_config.sv"
`include "transaction.sv"
`include "sequences.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"

module tb;
  spi_if vif();
  dut dut_inst (
    .write_en(vif.write_en),
    .clk     (vif.clk),
    .rst_n   (vif.rst_n),
    .addr    (vif.addr),
    .data_in (vif.data_in),
    .data_out(vif.data_out),
    .done    (vif.done),
    .error   (vif.error)
  );

  initial vif.clk = 0;
  always #10 vif.clk = ~vif.clk;

  initial begin
    uvm_config_db#(virtual spi_if)::set(null, "*", "vif", vif);
    run_test("test");
  end
endmodule