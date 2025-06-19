class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)
    uvm_analysis_export #(spi_sequence_item) ap_export;  
    uvm_tlm_analysis_fifo #(spi_sequence_item) fifo;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap_export = new("ap_export", this); 
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo = new("fifo", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        ap_export.connect(fifo.analysis_export);  
    endfunction
    
    task run_phase(uvm_phase phase);
        spi_sequence_item item;
        forever begin
            fifo.get(item);
            if (item.rx_data === 8'hAA) 
                `uvm_info("SCOREBOARD", $sformatf("PASS: tx=0x%0h, rx=0x%0h", item.tx_data, item.rx_data), UVM_LOW)
            else
                `uvm_error("SCOREBOARD", $sformatf("FAIL: rx=0x%0h, expected=0xAA", item.rx_data))
        end
    endtask
endclass