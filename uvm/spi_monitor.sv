class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)
    virtual spi_if vif;
    uvm_analysis_port #(spi_sequence_item) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            spi_sequence_item item = spi_sequence_item::type_id::create("item");
            
            // Wait for reset to complete if needed
            @(posedge vif.clk iff vif.rst_n);
            
            // Wait for start of transaction
            @(posedge vif.start);
            
            // Wait for completion
            @(posedge vif.done);
            
            // Capture transaction
            item.tx_data = vif.data_in;
            item.rx_data = vif.data_out;
            
            analysis_port.write(item);
        end
    endtask
endclass