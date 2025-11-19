`include "uvm_macros.svh"
package pkg;
  int count;
  reg [10:0] uart_pkt;
  import uvm_pkg::*;
  `include "defines.sv"

  `include "seq_item.sv"
  `include "sequence.sv"
  `include "sequencer.sv"

  `include "driver.sv"
  `include "monitor.sv"

  `include "agent.sv"

  `include "scoreboard.sv"
  `include "coverage.sv"
  `include "environment.sv"
  `include "test.sv"
endpackage
