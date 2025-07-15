class driver extends uvm_driver#(transaction);
      `uvm_component_utils(driver)
    
      virtual spi_if vif;
      transaction tr;
    
      function new(string path = "drv", uvm_component parent = null);
         super.new(path, parent);
      endfunction
    
      virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
    
        if (!uvm_config_db#(virtual spi_if)::get(this, "", "vif", vif)) begin
          `uvm_error("DRV", "Unable to access Interface");end
        else begin
          `uvm_info(" DRV", "~ [DRIVER] Access Interface is Successful ~ ", UVM_NONE) end

      endfunction : build_phase
    

      task reset_dut();

           repeat (5) begin
                 vif.rst_n     <= 1'b0;
                 vif.addr      <= 'h0;
                 vif.data_in   <= 'h0;
                 vif.write_en  <= 1'b0;
                 `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
                 @(posedge vif.clk);
           end

      endtask : reset_dut
    

      task drive();

        reset_dut();

        forever begin

          seq_item_port.get_next_item(tr);
          
          case (tr.op)

               RESET: begin
                     vif.rst_n <= 1'b0; // ACTIVE_LOW
                     @(posedge vif.clk);
               end

               WRITE: begin
                     vif.rst_n     <= 1'b1;
                     vif.write_en  <= 1'b1;
                     vif.addr      <= tr.addr;
                     vif.data_in   <= tr.data_in;
                     @(posedge vif.clk);
                     `uvm_info("DRV", $sformatf("WRITE addr:%0d data:%0d", vif.addr, vif.data_in), UVM_NONE);
                     @(posedge vif.done);
               end

               READ: begin
                    vif.rst_n     <= 1'b1;
                    vif.write_en  <= 1'b0;
                    vif.addr      <= tr.addr;
                    @(posedge vif.clk);
                    `uvm_info("DRV", $sformatf("READ addr:%0d", vif.addr), UVM_NONE);
                    @(posedge vif.done);
               end

          endcase

          seq_item_port.item_done();

        end
      endtask : drive
    

      virtual task run_phase(uvm_phase phase);
        drive();
      endtask : run_phase

endclass