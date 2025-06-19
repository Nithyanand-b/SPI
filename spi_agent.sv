
class spi_agent extends uvm_agent;
  `uvm_component_utils(spi_agent)
  
  spi_driver    driver;
  spi_monitor   monitor;
  spi_sequencer sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor   = spi_monitor::type_id::create("monitor", this);
    driver    = spi_driver::type_id::create("driver", this);
    sequencer = spi_sequencer::type_id::create("sequencer", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass