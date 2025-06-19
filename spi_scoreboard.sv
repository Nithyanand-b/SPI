// SPI Scoreboard
class spi_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(spi_scoreboard)

  //---------------------------------------
  // Analysis import declaration
  //---------------------------------------
  uvm_analysis_imp#(spi_seq_item, spi_scoreboard) mon_imp;

  //---------------------------------------
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_imp = new("mon_imp", this);
  endfunction

  //---------------------------------------
  // Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  //---------------------------------------
  // Write function implementation
  //---------------------------------------
  function void write(spi_seq_item trans);
    // trans.print();

    `uvm_info("SPI_SCOREBOARD", $sformatf("------::RESULT:: ------"), UVM_LOW)
    `uvm_info("", $sformatf("data_in_master : %0h  data_in_slave : %0h",
                            trans.data_in_master, trans.data_in_slave), UVM_LOW)
    `uvm_info("", $sformatf("data_out_master: %0h  data_out_slave: %0h",
                            trans.data_out_master, trans.data_out_slave), UVM_LOW)

    if (trans.data_in_master == trans.data_out_slave)
      `uvm_info("SPI_SCOREBOARD", "------ ::DATA TRANSACTION FROM MASTER TO SLAVE SUCCESSFUL:: ------", UVM_LOW)
    else
      `uvm_info("SPI_SCOREBOARD", "------ ::DATA TRANSACTION FROM MASTER TO SLAVE FAILED:: ------", UVM_LOW)

    if (trans.data_in_slave == trans.data_out_master)
      `uvm_info("SPI_SCOREBOARD", "------ ::DATA TRANSACTION FROM SLAVE TO MASTER SUCCESSFUL:: ------", UVM_LOW)
    else
      `uvm_info("SPI_SCOREBOARD", "------ ::DATA TRANSACTION FROM SLAVE TO MASTER FAILED:: ------", UVM_LOW)
  endfunction

endclass
