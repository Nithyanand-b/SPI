
class spi_seq_item extends uvm_sequence_item;
  rand  logic [7:0] mosi_data; // Data from master
  rand  logic [7:0] miso_data; // Data from slave
  logic [7:0] master_rx;      // Data received by master
  logic [7:0] slave_rx;       // Data received by slave

  `uvm_object_utils_begin(spi_seq_item)
    `uvm_field_int(mosi_data, UVM_DEFAULT)
    `uvm_field_int(miso_data, UVM_DEFAULT)
    `uvm_field_int(master_rx, UVM_DEFAULT)
    `uvm_field_int(slave_rx, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "spi_seq_item");
    super.new(name);
  endfunction
endclass