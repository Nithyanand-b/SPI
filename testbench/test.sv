class test extends uvm_test;
  `uvm_component_utils(test)

  env e;
  writeb_readb wr_rd;

  function new(string inst = "test", uvm_component c);
    super.new(inst, c);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e        = env::type_id::create("env", this);
    wr_rd    = writeb_readb::type_id::create("wr_rd");
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wr_rd.start(e.a.seqr);
    #20;
    phase.drop_objection(this);
  endtask

  
endclass




// class test extends uvm_test;


//   `uvm_component_utils(test)

//   env e;
//   reset_dut reset;

//   function new(string inst = "test", uvm_component c);
//     super.new(inst, c);
//   endfunction

//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     e        = env::type_id::create("env", this);
//     reset   = reset_dut::type_id::create("reset");
//   endfunction

//   virtual task run_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     reset.start(e.a.seqr);
//     #20;
//     phase.drop_objection(this);
//   endtask

  
// endclass