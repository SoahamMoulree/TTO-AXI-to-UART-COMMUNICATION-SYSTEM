class seq_item extends uvm_sequence_item;

  rand logic rst;
  rand logic axis_valid;
  rand logic axis_last;
  rand logic [7:0] axis_data;
  logic [7:0] rx_data;
  logic rx_valid, uart_tx, m_axis_ready;

  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(axis_valid , UVM_ALL_ON)
  `uvm_field_int(axis_last, UVM_ALL_ON)
  `uvm_field_int(axis_data, UVM_ALL_ON)
	`uvm_field_int(rx_data, UVM_ALL_ON)
	`uvm_field_int(uart_tx, UVM_ALL_ON)
	`uvm_field_int(m_axis_ready, UVM_ALL_ON)
	`uvm_field_int(rx_valid, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "seq_item");
  	super.new(name);
	endfunction

endclass

