class spi_driver extends uvm_driver #(spi_seq_item);
  `uvm_component_utils(spi_driver)
  
  virtual spi_if.tb_port vif;
  spi_seq_item req;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual spi_if.tb_port)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not set")
  endfunction

  virtual task run_phase(uvm_phase phase);
    // Wait for reset to complete
    wait(vif.rst_n == 1);
    vif.master_start = 0;
    vif.master_data_in = 0;
    vif.slave_data_in = 0;
    forever begin
      seq_item_port.get_next_item(req);
      drive_transfer(req);
      seq_item_port.item_done();
    end
  endtask

 task drive_transfer(spi_seq_item item);
  // Set slave data first
  @(posedge vif.clk);
  vif.slave_data_in = item.miso_data;
  `uvm_info("DRV", $sformatf("Slave MISO set to 0x%0h", item.miso_data), UVM_MEDIUM)
  
  // Wait 3 cycles for slave to load data
  repeat (3) @(posedge vif.clk);
  
  // Start master transfer
  vif.master_data_in = item.mosi_data;
  vif.master_start = 1;
  `uvm_info("DRV", $sformatf("Master start MOSI=0x%0h", item.mosi_data), UVM_MEDIUM)
  
  @(posedge vif.clk);
  vif.master_start = 0;
  
  // Wait for completion plus 2 cycles
  wait(!vif.master_busy);
  repeat (2) @(posedge vif.clk);
  `uvm_info("DRV", "Transfer complete", UVM_MEDIUM)
endtask
endclass