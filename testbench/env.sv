
class env extends uvm_env;
  `uvm_component_utils(env)

  agent a;
  sco s;

  function new(string inst = "env", uvm_component c);
    super.new(inst, c);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("a", this);
    s = sco::type_id::create("s", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    a.m.send.connect(s.recv);
  endfunction
endclass