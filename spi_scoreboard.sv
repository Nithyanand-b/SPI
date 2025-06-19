`include "uvm_macros.svh"
import uvm_pkg::*;

class spi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(spi_scoreboard)
  
  uvm_analysis_imp #(spi_seq_item, spi_scoreboard) item_export;
  spi_seq_item item_queue[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(spi_seq_item item);
    item_queue.push_back(item);
    check_transaction(item);
  endfunction

  function void check_transaction(spi_seq_item item);
    // Removed timing control and made it immediate check
    if (item.mosi_data !== item.slave_rx) 
      `uvm_error("SCBD", $sformatf("MOSI mismatch! Sent: 0x%0h, Received: 0x%0h", 
                 item.mosi_data, item.slave_rx))
    else
      `uvm_info("SCBD", $sformatf("MOSI match: 0x%0h", item.mosi_data), UVM_MEDIUM)

    if (item.miso_data !== item.master_rx) 
      `uvm_error("SCBD", $sformatf("MISO mismatch! Sent: 0x%0h, Received: 0x%0h", 
                 item.miso_data, item.master_rx))
    else
      `uvm_info("SCBD", $sformatf("MISO match: 0x%0h", item.miso_data), UVM_MEDIUM)
  endfunction
endclass