class transaction extends uvm_sequence_item;

      rand  oper_mode op;
      rand  logic     write_en;
            logic     rst_n;
      randc logic [7:0] addr;
      rand  logic [7:0] data_in;
            logic [7:0] data_out;
            logic       done;
            logic       error;

     `uvm_object_utils_begin(transaction)

          `uvm_field_enum(oper_mode, op, UVM_ALL_ON)
          `uvm_field_int(write_en, UVM_ALL_ON)
          `uvm_field_int(rst_n, UVM_ALL_ON)
          `uvm_field_int(addr, UVM_ALL_ON)
          `uvm_field_int(data_in, UVM_ALL_ON)
          `uvm_field_int(data_out, UVM_ALL_ON)
          `uvm_field_int(done, UVM_ALL_ON)
          `uvm_field_int(error, UVM_ALL_ON)

     `uvm_object_utils_end

      constraint addr_c { addr <= 10; }
      constraint addr_c_err { addr > 31; }

      function new(string name = "transaction");
          super.new(name);
      endfunction

endclass : transaction