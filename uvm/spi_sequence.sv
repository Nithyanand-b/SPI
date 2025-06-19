class spi_sequence extends uvm_sequence #(spi_sequence_item);
    `uvm_object_utils(spi_sequence)
    
    function new(string name = "spi_sequence");
        super.new(name);
    endfunction
    
    task body();
        spi_sequence_item item;
        repeat (10) begin
            item = spi_sequence_item::type_id::create("item");
            start_item(item);
            assert(item.randomize());
            finish_item(item);
        end
    endtask
endclass