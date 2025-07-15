
class sco extends uvm_scoreboard;
  `uvm_component_utils(sco)

  uvm_analysis_imp#(transaction, sco) recv;
  bit [7:0] mem[32] = '{default:0};

  function new(string inst = "sco", uvm_component parent = null);
    super.new(inst, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv = new("recv", this);
  endfunction

  virtual function void write(transaction tr);
    case (tr.op)
      RESET: `uvm_info("SCO", "Reset detected", UVM_NONE)
      WRITE: begin
        if (tr.error)
          `uvm_info("SCO", "WRITE Error Detected", UVM_NONE)
        else begin
          mem[tr.addr] = tr.data_in;
          `uvm_info("SCO", $sformatf("WRITE OK addr:%0d data:%0d", tr.addr, tr.data_in), UVM_NONE)
        end
      end
      READ: begin
        if (tr.error)
          `uvm_info("SCO", "READ Error Detected", UVM_NONE)
        else begin
          if (mem[tr.addr] == tr.data_out)
            `uvm_info("SCO", $sformatf("READ OK addr:%0d data:%0d", tr.addr, tr.data_out), UVM_NONE)
          else
            `uvm_error("SCO", $sformatf("READ MISMATCH addr:%0d expected:%0d got:%0d", tr.addr, mem[tr.addr], tr.data_out))
        end
      end
    endcase
    $display("----------------------------------------------------------------------");
  endfunction
endclass