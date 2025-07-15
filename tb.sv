`timescale 1ns / 1ps

`include "dut/spi_components.sv"

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