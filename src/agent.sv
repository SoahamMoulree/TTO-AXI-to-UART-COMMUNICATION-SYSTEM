class active_agent extends uvm_agent;
  
  `uvm_component_utils(active_agent)
  driver drv;
  active_monitor act_mon;
  sequencer seqr;
  
  function new(string name = "active_agent", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv = driver::type_id::create("drv",this);
      seqr = sequencer::type_id::create("seqr",this);
    end
    act_mon = active_monitor::type_id::create("active_monitor",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase( phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass

class passive_agent extends uvm_agent;

  `uvm_component_utils(passive_agent)
  passive_monitor pass_mon;

  function new(string name = "passive_agent",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pass_mon = passive_monitor::type_id::create("pass_mon",this);
  endfunction

endclass
