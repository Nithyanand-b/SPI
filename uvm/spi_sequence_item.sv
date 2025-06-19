class spi_sequence_item extends uvm_sequence_item;
    rand logic [7:0] tx_data;
    logic [7:0] rx_data;
    
    `uvm_object_utils_begin(spi_sequence_item)
        `uvm_field_int(tx_data, UVM_ALL_ON)
        `uvm_field_int(rx_data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "spi_sequence_item");
        super.new(name);
    endfunction
endclass