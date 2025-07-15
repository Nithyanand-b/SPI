
class agent extends uvm_agent;
  `uvm_component_utils(agent)

  spi_config cfg;
  driver d;
  mon m;
  uvm_sequencer#(transaction) seqr;

  function new(string inst = "agent", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = spi_config::type_id::create("cfg");
    m   = mon::type_id::create("m", this);
    if (cfg.is_active == UVM_ACTIVE) begin
      d    = driver::type_id::create("d", this);
      seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    if (cfg.is_active == UVM_ACTIVE)
      d.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass