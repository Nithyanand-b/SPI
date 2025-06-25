module top_dut (
  input        mclk,
  input        reset,
  input        load_master,
  input        load_slave,
  input        read_master,
  input        read_slave,
  input        start,
  input  [7:0] data_in_master,
  input  [7:0] data_in_slave,
  output [7:0] data_out_master,
  output [7:0] data_out_slave
);

  wire miso, mosi, cs, sclk;

  spi_master spi_master_ (
    .mclk(mclk),
    .reset(reset),
    .load(load_master),
    .read(read_slave),
    .miso(miso),
    .start(start),
    .data_in(data_in_master),
    .data_out(data_out_master),
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs)
  );

  spi_slave spi_slave_ (
    .sclk(sclk),
    .reset(reset),
    .cs(cs),
    .mosi(mosi),
    .miso(miso),
    .data_in(data_in_slave),
    .data_out(data_out_slave),
    .read(read_slave),
    .load(load_slave)
  );

  // Assertions
  property p1;
    @(posedge mclk) disable iff (!reset)
      load_master |-> !read_master;
  endproperty

  property p2;
    @(posedge mclk) disable iff (!reset)
      load_slave |-> !read_slave;
  endproperty

  property p3;
    @(posedge mclk) disable iff (!reset)
      (!load_master && !read_master) |-> (!load_slave && !read_slave);
  endproperty

  property p4;
    @(posedge mclk) disable iff (!reset)
      $fell(load_master) && $fell(load_slave) &&
      !$rose(read_master) && !$rose(read_slave) |=> 
      ($stable(load_master) && 
       $stable(load_slave) && 
       $stable(read_master) && 
       $stable(read_slave))[*8];
  endproperty

  assert property (p1)
    $display("MASTER: WHILE LOAD NO READ: PASSED");
  else
    $display("MASTER: WHILE LOAD NO READ: FAILED");

  assert property (p2)
    $display("SLAVE: WHILE LOAD NO READ: PASSED");
  else
    $display("SLAVE: WHILE LOAD NO READ: FAILED");

  assert property (p3)
    $display("MASTER SLAVE BOTH SHIFTING: PASSED");
  else
    $display("MASTER SLAVE BOTH SHIFTING: FAILED");

  assert property (p4)
    $display("CONTROL SIGNALS STABLE WHILE SHIFTING: PASSED");
  else
    $display("CONTROL SIGNALS NOT STABLE WHILE SHIFTING: FAILED");

endmodule
