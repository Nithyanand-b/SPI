class spi_driver extends uvm_driver #(spi_sequence_item);
    `uvm_component_utils(spi_driver)
    virtual spi_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            spi_sequence_item item;
            seq_item_port.get_next_item(item);
            
            // Wait for reset to complete - USE CORRECT SIGNAL
            @(posedge vif.clk iff vif.rst_n);  // Now valid
            
            // Drive transaction
            vif.start <= 1;
            vif.data_in <= item.tx_data;
            
            // Wait for completion
            @(posedge vif.clk iff vif.done);
            vif.start <= 0;
            
            seq_item_port.item_done();
        end
    endtask
endclass