
class spi_test extends uvm_test;
  `uvm_component_utils(spi_test)
  
  spi_env env;
  spi_simple_seq seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = spi_env::type_id::create("env", this);
    seq = spi_simple_seq::type_id::create("seq");
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
    `uvm_info("TEST", "Test completed", UVM_MEDIUM)
  endtask
endclass