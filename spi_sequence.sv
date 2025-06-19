
class spi_base_seq extends uvm_sequence #(spi_seq_item);
  `uvm_object_utils(spi_base_seq)

  function new(string name="spi_base_seq");
    super.new(name);
  endfunction
endclass

class spi_simple_seq extends spi_base_seq;
  `uvm_object_utils(spi_simple_seq)

  function new(string name="spi_simple_seq");
    super.new(name);
  endfunction

  task body();
    spi_seq_item tx;
    // Send known test patterns
    tx = spi_seq_item::type_id::create("tx");
    start_item(tx);
    tx.mosi_data = 8'hAA;
    tx.miso_data = 8'h55;
    `uvm_info("SEQ", $sformatf("Sending MOSI=0x%0h, MISO=0x%0h", tx.mosi_data, tx.miso_data), UVM_MEDIUM)
    finish_item(tx);
    
    tx = spi_seq_item::type_id::create("tx");
    start_item(tx);
    tx.mosi_data = 8'h55;
    tx.miso_data = 8'hAA;
    `uvm_info("SEQ", $sformatf("Sending MOSI=0x%0h, MISO=0x%0h", tx.mosi_data, tx.miso_data), UVM_MEDIUM)
    finish_item(tx);
    
    tx = spi_seq_item::type_id::create("tx");
    start_item(tx);
    tx.mosi_data = 8'h01;
    tx.miso_data = 8'h80;
    `uvm_info("SEQ", $sformatf("Sending MOSI=0x%0h, MISO=0x%0h", tx.mosi_data, tx.miso_data), UVM_MEDIUM)
    finish_item(tx);
  endtask
endclass