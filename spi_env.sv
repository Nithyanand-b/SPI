
class spi_env extends uvm_env;
  `uvm_component_utils(spi_env)
  
  spi_agent      agent;
  spi_scoreboard scbd;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = spi_agent::type_id::create("agent", this);
    scbd  = spi_scoreboard::type_id::create("scbd", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.ap.connect(scbd.item_export);
  endfunction
endclass