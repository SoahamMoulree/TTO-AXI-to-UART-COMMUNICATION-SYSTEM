
class active_monitor extends uvm_monitor;

  `uvm_component_utils(active_monitor)
  seq_item act_seq;
  virtual intf vif;
  uvm_analysis_port#(seq_item)act_mon_port;
  uvm_analysis_port#(seq_item)act_mon_cg_port;

  function new(string name = "monitor", uvm_component parent);
    super.new(name,parent);
    act_mon_port = new("act_mon_port",this);
    act_mon_cg_port = new("act_mon_cg_port",this);
    act_seq = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db#(virtual intf)::get(this, "", "vif",vif)) begin
      `uvm_error(get_type_name,"Failed to get interface in active_monitor")
    end
  endfunction

  task monitor_act_val;
    /*if(vif.rst) begin
      act_seq.rst = vif.rst;
      act_seq.axis_data = 0;
      act_seq.axis_valid = 0;
      act_seq.axis_last = vif.axis_last;
      act_seq.m_axis_ready = act_seq.m_axis_ready;
      act_mon_port.write(act_seq);
    end
      else begin*/
      act_seq.rst = vif.rst;
      act_seq.axis_data = vif.axis_data;
      act_seq.axis_valid = vif.axis_valid;
      act_seq.axis_last = vif.axis_last;
      act_seq.m_axis_ready = act_seq.m_axis_ready;
      act_mon_port.write(act_seq);
      act_mon_cg_port.write(act_seq);
      //end	
  endtask

  task run_phase(uvm_phase phase);
    repeat(1)@(vif.act_mon_cb);
    forever begin
      if(vif.rst || vif.axis_valid || vif.axis_valid == 0) monitor_act_val();
      `uvm_info(get_type_name, $sformatf(" | MONITOR | DATA = %0d | AXIS_VALID = %0d | AXIS_LAST = %0d |",act_seq.axis_data,act_seq.axis_valid,act_seq.axis_last),UVM_MEDIUM)
      repeat(1)@(vif.act_mon_cb);
    end
  endtask

endclass

class passive_monitor extends uvm_monitor;
  `uvm_component_utils(passive_monitor)
  uvm_analysis_port#(seq_item)passive_mon_port;
  uvm_analysis_port#(seq_item)pass_mon_cg_port;
  seq_item pass_seq;
  virtual intf vif;
  bit first_tx;
  bit [7:0] temp;
  bit [10:0] temp_uart_pkt;

  function new(string name = "passive_monitor",uvm_component parent);
    super.new(name,parent);
    passive_mon_port = new("passive_mon_port",this);
    pass_mon_cg_port = new("pass_mon_cg_port",this);
    pass_seq = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this, "", "vif",vif)) begin
      `uvm_error(get_type_name,"Failed to get interface in active_monitor")
    end
  endfunction

  task monitor_ready_sig;
    pass_seq.m_axis_ready = vif.m_axis_ready;
  endtask

  task monitor_uart_tx;
    repeat(434)@(vif.pass_mon_cb);
    pass_seq.uart_tx = vif.uart_tx;
  endtask

  task temp_uart_pkt_cat;
    int i;
    bit parity;
    //wait(vif.uart_tx == 0);
    temp_uart_pkt = 0;

    for (i = 0; i < 11; i++) begin
      repeat(434) @(vif.pass_mon_cb);
      temp_uart_pkt[i] = vif.uart_tx; 
    end
    temp = temp_uart_pkt[8:1];
    uart_pkt = temp_uart_pkt;
    uvm_config_db#(int)::set(null,"*","temp",temp);

    $display("");
    $display("****************************************************************");  
    $display("*************** UART_PKT (BIN) = %b ****************************", temp_uart_pkt);
    $display("*************** UART_PKT (DEC) = %0d ****************************", temp);
    $display("****************************************************************");
    $display("");
  endtask


  task monitor_rx_val();
    /* if(first_tx == 0) begin
      repeat(9342)@(vif.pass_mon_cb);
      pass_seq.rx_data = vif.rx_data;
      pass_seq.rx_valid = vif.rx_valid;
      first_tx = 1;
    end*/
      //else begin
      repeat(4774)@(vif.pass_mon_cb);
      pass_seq.rx_data = vif.rx_data;
      //pass_seq.rx_valid = vif.rx_valid;
  endtask

  task detect_rx_valid_pulse();
    repeat(1)@(vif.pass_mon_cb);

    if(vif.rx_valid === 1'b1) begin
      pass_seq.rx_valid = vif.rx_valid;
      $display("");
      $display("~~~  RX_VALID PULSE DETECTED @ %0t ~~~", $time);
      $display("~~~ RX_DATA = %0d ~~~", vif.rx_data );
      $display("");
    end
  endtask

  task run_phase(uvm_phase phase);
    fork
      repeat(1)@(vif.pass_mon_cb);
      forever begin
        monitor_ready_sig();
        `uvm_info(get_type_name(), $sformatf(" | M_AXIS_READY = %0d |",pass_seq.m_axis_ready),UVM_MEDIUM)
        pass_mon_cg_port.write(pass_seq);
        repeat(1)@(vif.pass_mon_cb);
      end
      forever begin
        monitor_uart_tx();
        `uvm_info(get_type_name(),$sformatf("| UART_TX = %0d |",pass_seq.uart_tx),UVM_MEDIUM)
        repeat(1)@(vif.pass_mon_cb);
      end
      forever begin
        monitor_rx_val();
        $display("");
        $display("");
        `uvm_info(get_type_name(),$sformatf(" | RX_VALID = %0d | RX_DATA = %0d ",pass_seq.rx_valid,pass_seq.rx_data),UVM_MEDIUM)
        $display("");
        $display("");
        count --;
        passive_mon_port.write(pass_seq);
      end
      forever begin
        detect_rx_valid_pulse();
      end
      forever begin
        temp_uart_pkt_cat();
      end    
    join_none
  endtask
endclass


