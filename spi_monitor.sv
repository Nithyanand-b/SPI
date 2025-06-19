// SPI Monitor
`define MON_IF vif.MONITOR.monitor_cb

class spi_monitor extends uvm_monitor;

  virtual spi_interface vif;

  //---------------------------------------
  // Analysis port declaration
  //---------------------------------------
  uvm_analysis_port#(spi_seq_item) ap;

  `uvm_component_utils(spi_monitor)

  //---------------------------------------
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  //---------------------------------------
  // Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual spi_interface)::get(this, "", "vif", vif)) begin
      `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
    end
  endfunction

  //---------------------------------------
  // Run phase
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    wait (`MON_IF.start);

    forever begin
      spi_seq_item trans;
      trans = new();

      // Wait for both masters and slaves to load
      wait (`MON_IF.load_master == 1 && `MON_IF.load_slave == 1);
      fork
        trans.data_in_master = `MON_IF.data_in_master;
        trans.data_in_slave  = `MON_IF.data_in_slave;
      join

      wait (`MON_IF.load_master == 0 && `MON_IF.load_slave == 0);

      // Wait 8 clock cycles (transfer period)
      repeat (8) begin
        @(posedge vif.MONITOR.mclk);
      end

      // Wait for both masters and slaves to read
      wait (`MON_IF.read_master == 1 && `MON_IF.read_slave == 1);
      fork
        trans.data_out_master = `MON_IF.data_out_master;
        trans.data_out_slave  = `MON_IF.data_out_slave;
      join  

      ap.write(trans);
    end
  endtask

endclass
