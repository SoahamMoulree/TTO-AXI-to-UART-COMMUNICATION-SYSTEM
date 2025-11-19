`uvm_analysis_imp_decl(_act_cg)
`uvm_analysis_imp_decl(_pass_cg)

class coverage extends uvm_component;
  `uvm_component_utils(coverage)
  uvm_analysis_imp_act_cg#(seq_item,coverage)act_cg_imp;
  uvm_analysis_imp_pass_cg#(seq_item,coverage)pass_cg_imp;
  seq_item act_item;
  seq_item pass_item;
  
  covergroup input_cg;
    AXIS_DATA_CP: coverpoint act_item.axis_data {
      bins range1 = {[0:85]};
      bins range2 = {[86:170]};
      bins range3 = {[171:255]};
    }
    AXIS_VALID_CP: coverpoint act_item.axis_valid {
      bins low = {0};
      bins high = {1};
    }
    AXIS_LAST_CP: coverpoint act_item.axis_last {
      bins low = {0};
      bins high = {1};
    }
    CROSS_CP: cross AXIS_VALID_CP, AXIS_LAST_CP;
  endgroup
  
  covergroup output_cg;
    RX_DATA_CP: coverpoint pass_item.rx_data {
      bins range1 = {[0:85]};
      bins range2 = {[86:170]};
      bins range3 = {[171:255]};
    }
    RX_VALID_CP: coverpoint pass_item.rx_valid {
      bins high = {1};
    }
    M_AXIS_READY_CP: coverpoint pass_item.m_axis_ready {
      bins low = {0};
      bins high = {1};
    }
   UART_TX_CP:coverpoint pass_item.uart_tx {
        bins low={0};
        bins high ={1};
		}
  endgroup 

  
  function new(string name, uvm_component parent);
    super.new(name, parent);
		input_cg = new();
		output_cg = new();
    act_cg_imp = new("act_cg_imp",this);
    pass_cg_imp = new("pass_cg_imp",this);
  endfunction
  
  virtual function void write_act_cg(seq_item t);
    act_item = t;
    input_cg.sample();
  endfunction

  virtual function void write_pass_cg(seq_item t);
    pass_item = t;
    output_cg.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE", $sformatf("Input Coverage: %.2f%%", input_cg.get_inst_coverage()), UVM_LOW)
    `uvm_info("COVERAGE", $sformatf("OUTPUT Coverage: %.2f%%", output_cg.get_inst_coverage()), UVM_LOW)
    
  endfunction
endclass
