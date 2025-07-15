// //       ::: WRITE DATA ONLY SEQUENCE :::       \\       

// class write_data extends uvm_sequence#(transaction);
 
//       `uvm_object_utils(write_data)
      
//       transaction tr;

//       function new(string name = "write_data");
//         super.new(name);
//       endfunction

//   virtual task body();
//     repeat (15) begin
//       tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(1);
//       tr.addr_c_err.constraint_mode(0);
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = WRITE;
//       finish_item(tr);
//     end
//   endtask
// endclass

// //       ::: WRITE ERROR SEQUENCE :::       \\

// class write_err extends uvm_sequence#(transaction);
//   `uvm_object_utils(write_err)
//   transaction tr;

//   function new(string name = "write_err");
//     super.new(name);
//   endfunction

//   virtual task body();
//     repeat (15) begin
//       tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(0);
//       tr.addr_c_err.constraint_mode(1);
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = WRITE;
//       finish_item(tr);
//     end
//   endtask
// endclass

// //       ::: READ DATA ONLY SEQUENCE :::       \\

// class read_data extends uvm_sequence#(transaction);
//   `uvm_object_utils(read_data)
//   transaction tr;

//   function new(string name = "read_data");
//     super.new(name);
//   endfunction

//   virtual task body();
//     repeat (15) begin
//       tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(1);
//       tr.addr_c_err.constraint_mode(0);
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = READ;
//       finish_item(tr);
//     end
//   endtask
// endclass

// //       ::: READ ERROR SEQUENCE :::       \\

// class read_err extends uvm_sequence#(transaction);
//   `uvm_object_utils(read_err)
//   transaction tr;

//   function new(string name = "read_err");
//     super.new(name);
//   endfunction

//   virtual task body();
//     repeat (15) begin
//       tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(0);
//       tr.addr_c_err.constraint_mode(1);
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = READ;
//       finish_item(tr);
//     end
//   endtask
// endclass

// //       ::: RESET SEQUENCE :::       \\

// class reset_dut extends uvm_sequence#(transaction);
//   `uvm_object_utils(reset_dut)
//   transaction tr;

//   function new(string name = "reset_dut");
//     super.new(name);
//   endfunction

//   virtual task body();
//     repeat (15) begin
//       tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(1);
//       tr.addr_c_err.constraint_mode(0);
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = RESET;
//       finish_item(tr);
//     end
//   endtask
// endclass

//       ::: WRITE & READ SEQUENCE GENERATOR :::       \\

class writeb_readb extends uvm_sequence#(transaction);
      `uvm_object_utils(writeb_readb)
      transaction tr;
    
      function new(string name = "writeb_readb");
        super.new(name);
      endfunction
    
      virtual task body();
        repeat (10) begin
          tr = transaction::type_id::create("tr");
          tr.addr_c.constraint_mode(1);
          tr.addr_c_err.constraint_mode(0);
          start_item(tr);
          assert(tr.randomize());
          tr.op = WRITE;
          finish_item(tr);
        end
    
        repeat (10) begin
          tr = transaction::type_id::create("tr");
          tr.addr_c.constraint_mode(1);
          tr.addr_c_err.constraint_mode(0);
          start_item(tr);
          assert(tr.randomize());
          tr.op = READ;
          finish_item(tr);
        end
      endtask
endclass