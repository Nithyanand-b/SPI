
class mon extends uvm_monitor;
  `uvm_component_utils(mon)

  uvm_analysis_port#(transaction) send;
  transaction tr;
  virtual spi_if vif;

  function new(string inst = "mon", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr   = transaction::type_id::create("tr");
    send = new("send", this);
    if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif)) begin
      `uvm_error("MON", "Unable to access Interface"); end
    else begin
          `uvm_info("MON", "~ [MONITOR] Access Interface is Successful ~ ", UVM_NONE) end

  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      if (!vif.rst_n) begin
        tr.op = RESET;
        `uvm_info("MON", "RESET DETECTED", UVM_NONE);
        send.write(tr);
      end else if (vif.write_en) begin
        @(posedge vif.done);
        tr.op     = WRITE;
        tr.addr   = vif.addr;
        tr.data_in = vif.data_in;
        tr.error  = vif.error;
        `uvm_info("MON", $sformatf("WRITE MON addr:%0d data:%0d err:%0d", tr.addr, tr.data_in, tr.error), UVM_NONE);
        send.write(tr);
      end else begin
        @(posedge vif.done);
        tr.op      = READ;
        tr.addr    = vif.addr;
        tr.data_out = vif.data_out;
        tr.error   = vif.error;
        `uvm_info("MON", $sformatf("READ MON addr:%0d data:%0d err:%0d", tr.addr, tr.data_out, tr.error), UVM_NONE);
        send.write(tr);
      end
    end
  endtask
endclass