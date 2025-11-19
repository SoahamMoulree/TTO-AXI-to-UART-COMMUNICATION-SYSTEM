`uvm_analysis_imp_decl(_mon_pass)
`uvm_analysis_imp_decl(_mon_act)

class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)
  uvm_analysis_imp_mon_act #(seq_item, scoreboard) active_imp;
  uvm_analysis_imp_mon_pass #(seq_item, scoreboard) passive_imp;

  seq_item act_mon_queue[$];
  seq_item pass_mon_queue[$];
  seq_item act_ref_pkt,pass_ref_pkt;
  bit [7:0] ref_data;
  bit [7:0] ref_fifo[$:8];
  bit [7:0] parity_queue[$];
  bit ref_parity,act_parity;
  bit ref_full;

  int match, mismatch,rx_valid_match,rx_valid_mismatch,ready_match,ready_mismatch;
  bit ref_rx_valid;

  function new(string name = "scoreboard", uvm_component parent);
    super.new(name,parent);
    active_imp = new("active_imp",this);
    passive_imp = new("passive_imp",this);
    act_ref_pkt = new();
    pass_ref_pkt = new();
  endfunction

  function void write_mon_act(seq_item req);
    act_mon_queue.push_back(req);
    //full_chk;
  endfunction

  function void write_mon_pass(seq_item req);
    pass_mon_queue.push_back(req);
  endfunction

  task act_mem_fifo;
    wait(act_mon_queue.size > 0);
    act_ref_pkt = act_mon_queue.pop_front;
		if(act_ref_pkt.rst) begin
			act_ref_pkt.axis_data = 8'b0;
			foreach(ref_fifo[i]) ref_fifo[i] = 8'b0;
			ref_fifo.push_back(act_ref_pkt.axis_data);
		end
		foreach(ref_fifo[i]) begin
			if(i != 0) begin
				if(ref_fifo[i] == 0 && ref_fifo[i-1] == 0)
					ref_fifo.delete(i);
			end
		end
		if(ref_fifo[0] == 0 && ref_fifo[1] == 0) ref_fifo.delete(1);
		if(act_ref_pkt.axis_valid && !act_ref_pkt.rst)			
    	ref_fifo.push_back(act_ref_pkt.axis_data);
  endtask
  
  task data_cmp;
    bit [7:0]temp;
    bit [7:0]temp_data;
    wait(pass_mon_queue.size > 0);
    pass_ref_pkt = pass_mon_queue.pop_front();
    if(ref_fifo.size > 0) begin
      if(ref_fifo.size == 9) begin
        ref_full = 0;
        if(ref_full == pass_ref_pkt.m_axis_ready) begin
          $display("");
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),"****************************** MATCH **********************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf("***************** ref_ready = %0d | act_ready = %0d *********************", ref_full, pass_ref_pkt.m_axis_ready),UVM_MEDIUM)
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          $display("");
          ready_match++; 
        end
        else begin
          $display("");
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),"****************************** MIS-MATCH **********************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf("***************** ref_ready = %0d | act_ready = %0d *********************", ref_full, pass_ref_pkt.m_axis_ready),UVM_MEDIUM)
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          $display("");
          ready_mismatch ++;
        end
      end
      else begin
        ref_full = 1;
        if(ref_full == pass_ref_pkt.m_axis_ready ) begin
          $display("");
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),"****************************** MATCH **********************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf("***************** ref_ready = %0d | act_ready = %0d *********************", ref_full, pass_ref_pkt.m_axis_ready),UVM_MEDIUM)
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          $display("");
          ready_match++; 
        end
        else begin
          $display("");
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),"****************************** MIS-MATCH **********************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf("***************** ref_ready = %0d | act_ready = %0d *********************", ref_full, pass_ref_pkt.m_axis_ready),UVM_MEDIUM)
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          $display("");
          ready_mismatch ++;
        end
      end
      $display("size of ref_fifo = %0d",ref_fifo.size);
      $display("%p",ref_fifo);
      ref_data = ref_fifo.pop_front;
      if(ref_data == pass_ref_pkt.rx_data) begin
        $display("");
        `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
        `uvm_info(get_type_name(),"****************************** MATCH **********************************", UVM_MEDIUM)
        `uvm_info(get_type_name(),$sformatf("***************** ref_data = %0d | act_data = %0d *********************", ref_data, pass_ref_pkt.rx_data),UVM_MEDIUM)
        `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
        $display("");
        match++;
      end
      else begin
        $display("");
        `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
        `uvm_info(get_type_name(),"*************************** MISMATCH **********************************", UVM_MEDIUM)
        `uvm_info(get_type_name(),$sformatf("*********** ref_data = %0d | act_data = %0d *****************", ref_data, pass_ref_pkt.rx_data),UVM_MEDIUM)
        `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
        $display("");
        mismatch ++;
      end
    end    
    
    uvm_config_db#(int)::get(this,"","temp",temp);
    
    parity_queue.push_back(temp);
    $display("%p",parity_queue);
    if(parity_queue.size > 0) begin
      act_parity = ^pass_ref_pkt.rx_data;
      temp_data = parity_queue.pop_front();
      ref_parity = ^temp_data;
      $display("entering here ");
      $display("rx_data = %0d(%08b)",pass_ref_pkt.rx_data,pass_ref_pkt.rx_data);
      $display("temp_data = %0d(%08b)",temp_data,temp_data);
      $display("ref_parity = %0b | act_parity = %0b",ref_parity,act_parity);
      if((ref_parity == act_parity))begin
        $display("2nd enter");
        ref_rx_valid = 1;
        if(ref_rx_valid == pass_ref_pkt.rx_valid) begin
          $display("");
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),"************************** RX_VALID MATCH *****************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf("***************** ref_valid = %0d | act_valid = %0d *********************", ref_rx_valid, pass_ref_pkt.rx_valid),UVM_MEDIUM)
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          $display("");
          rx_valid_match ++; 
        end
        else begin
           $display("");
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),"************************** RX_VALID MISMATCH *****************************", UVM_MEDIUM)
          `uvm_info(get_type_name(),$sformatf("***************** ref_valid = %0d | act_valid = %0d *********************", ref_rx_valid, pass_ref_pkt.rx_valid),UVM_MEDIUM)
          `uvm_info(get_type_name(),"***********************************************************************", UVM_MEDIUM)
          $display("");
          rx_valid_mismatch ++;
        end
      end
    end
    $display("");
    $display("------------------------------ SCB ----------------------------------");
  endtask

  task run_phase(uvm_phase phase);
    fork
      forever begin
        act_mem_fifo();
      end
      forever begin
        data_cmp();
      end
    join_none
  endtask
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("\n|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    $display("\n============================================ TOTAL TEST-CASES PASSED ===========================================================");
    
    $display("-------------------------------------------------  DATA-MATCHES = %0d ------------------------------------------------------------",match);
    $display("-------------------------------------------  M-AXIS-READY_MATCHES = %0d  ---------------------------------------------------------",ready_match);
    $display("--------------------------------------------   RX_VALID_MATCHES = %0d   -------------------------------------------------------------",rx_valid_match);
    $display("\n============================================ TOTAL TEST-CASES PASSED ===========================================================");
    $display("\n|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
    $display("\n============================================= TOTAL TEST-CASES FAILED ========================================================== ");
    $display("\n---------------------------------------------  DATA - MIS-MATCHES = %0d  -----------------------------------------------------------",mismatch);
    $display("-----------------------------------------   M_AXIS_READY MIS - MATCHES = %0d   -----------------------------------------------------",ready_mismatch);
    $display("-------------------------------------------   RX_VALID MIS - MATCHES = %0d  -------------------------------------------------------",rx_valid_mismatch);

    $display("=========================================== TOTAL TEST-CASES PASSED/FAILED =======================================================");
    $display("\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");



  endfunction
endclass
