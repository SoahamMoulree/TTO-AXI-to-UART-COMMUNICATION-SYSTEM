class env extends uvm_env;

  `uvm_component_utils(env)
  active_agent act_agt;
  passive_agent pass_agt;
  scoreboard scb;
  coverage cov;
  function new(string name = "env", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    set_config_int("pass_agt","is_active",UVM_PASSIVE);
    set_config_int("act_agt","is_active",UVM_ACTIVE);
    act_agt = active_agent::type_id::create("act_agt",this);
    pass_agt = passive_agent::type_id::create("pass_agt",this);
    scb = scoreboard::type_id::create("scb",this);
    cov = coverage::type_id::create("cov",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    act_agt.act_mon.act_mon_port.connect(scb.active_imp);
    act_agt.act_mon.act_mon_cg_port.connect(cov.act_cg_imp);
    pass_agt.pass_mon.pass_mon_cg_port.connect(cov.pass_cg_imp);
    pass_agt.pass_mon.passive_mon_port.connect(scb.passive_imp);
  endfunction

endclass
