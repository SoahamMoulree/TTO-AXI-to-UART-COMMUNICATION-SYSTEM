class driver extends uvm_driver#(seq_item);

  `uvm_component_utils(driver)

  virtual intf vif;

  function new(string name = "driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db#(virtual intf)::get(this,"","vif",vif)) begin
      `uvm_error(get_type_name(), "Failed to get interface in driver !")
    end
  endfunction

  task drive_val();
    vif.rst <= req.rst;
    vif.axis_data <= req.axis_data;
    vif.axis_valid <= req.axis_valid;

    if(req.axis_last) begin
      repeat(1)@(vif.drv_cb);
      vif.axis_last <= 1;
    end
    else begin
      vif.axis_last <= 0;
    end
  endtask

  task run_phase(uvm_phase phase);
    repeat(1)@(vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      $display("count = %0d",count);
      drive_val();
      `uvm_info(get_type_name(), $sformatf("DRIVER | RST = %0b | DATA = %0d | AXIS_VALID = %0d | AXIS_LAST = %0d |",req.rst,req.axis_data,req.axis_valid,req.axis_last), UVM_MEDIUM)
       seq_item_port.item_done(); 
      repeat(1)@(vif.drv_cb);
    end
  endtask

endclass
