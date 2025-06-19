class spi_monitor extends uvm_monitor;
  `uvm_component_utils(spi_monitor)
  
  uvm_analysis_port #(spi_seq_item) ap;
  virtual spi_if.tb_port vif;
  spi_seq_item item;
  
  covergroup spi_cg;
    MOSI: coverpoint item.mosi_data {
      bins zero = {0};
      bins low  = {[1:84]};
      bins mid  = {[85:170]};
      bins high = {[171:255]};
    }
    MISO: coverpoint item.miso_data {
      bins zero = {0};
      bins low  = {[1:84]};
      bins mid  = {[85:170]};
      bins high = {[171:255]};
    }
    CROSS: cross MOSI, MISO;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    spi_cg = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual spi_if.tb_port)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not set")
  endfunction

 virtual task run_phase(uvm_phase phase);
  // Wait for reset to complete
  wait(vif.rst_n == 1);
  
  forever begin
    @(posedge vif.master_start);
    item = spi_seq_item::type_id::create("item");
    item.mosi_data = vif.master_data_in;
    item.miso_data = vif.slave_data_in;
    
    // Wait for transfer completion plus 5 cycles for data to settle
    wait(!vif.master_busy);
    repeat (5) @(posedge vif.clk);
    
    item.master_rx = vif.master_data_out;
    item.slave_rx  = vif.slave_data_out;
    
    `uvm_info("MON", $sformatf("MOSI=0x%0h MISO=0x%0h MasterRX=0x%0h SlaveRX=0x%0h", 
               item.mosi_data, item.miso_data, item.master_rx, item.slave_rx), UVM_MEDIUM)
    
    ap.write(item);
    spi_cg.sample();
  end
endtask
endclass