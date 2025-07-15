typedef enum bit [2:0] {
  READ = 0, WRITE = 1, RESET = 2, WRITE_ERR = 3, READ_ERR = 4
} oper_mode;

class spi_config extends uvm_object;
  `uvm_object_utils(spi_config)

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new(string name = "spi_config");
    super.new(name);
  endfunction
endclass