class test extends uvm_test;

  `uvm_component_utils(test)
  env e;
  base_sequence seq;
    

  function new(string name = "test", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = base_sequence::type_id::create("seq");
    seq.start(e.act_agt.seqr);
    #900000;
    phase.drop_objection(this);
  endtask

endclass

class test2 extends test;

  `uvm_component_utils(test2)

  function new(string name = "test2",uvm_component parent);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    sequence2 seq2;
    phase.raise_objection(this);
    seq2 = sequence2::type_id::create("seq2");
    seq2.start(e.act_agt.seqr);
    #900000;
    phase.drop_objection(this);
  endtask

endclass

class reset_test extends test;

		`uvm_component_utils(reset_test)

		function new(string name = "reset_test",uvm_component parent = null);
			super.new(name,parent);
		endfunction

		task run_phase(uvm_phase phase);
			sequence1 seq;
			phase.raise_objection(this);
			seq = sequence1::type_id::create("seq");
			seq.start(e.act_agt.seqr);
			phase.drop_objection(this);
			phase.phase_done.set_drain_time(this,2000000);
		endtask

endclass

class valid_last_test extends test;
		`uvm_component_utils(valid_last_test)

		function new(string name = "valid_last_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction

	  virtual task run_phase(uvm_phase phase);
			sequence7 seq7;
			seq7 = sequence7::type_id::create("seq7");
			phase.raise_objection(this);
			seq7.start(e.act_agt.seqr);
			phase.drop_objection(this);
			phase.phase_done.set_drain_time(this, 200000);
		endtask
endclass

class data_drive_test extends test;
		`uvm_component_utils(data_drive_test)

		function new(string name = "data_drive_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		virtual task run_phase(uvm_phase phase);
			sequence8 seq8;
			seq8 = sequence8::type_id::create("seq8");
			phase.raise_objection(this);
			seq8.start(e.act_agt.seqr);
			phase.drop_objection(this);
			phase.phase_done.set_drain_time(this, 5000000);
		endtask
endclass

class fifo_full_test extends test;

		`uvm_component_utils(fifo_full_test)
		function new(string name = "fifo_full_test",uvm_component parent = null);
			super.new(name,parent);
		endfunction

		task run_phase(uvm_phase phase);
			sequence4 seq;
		  phase.raise_objection(this);
			seq=sequence4::type_id::create("seq");
		  seq.start(e.act_agt.seqr);
			phase.drop_objection(this);
			phase.phase_done.set_drain_time(this,900000);
		endtask

		virtual function void end_of_elaboration();
			print();
		endfunction

endclass

class drive_last_test extends test;

		`uvm_component_utils(drive_last_test)

		function new(string name = "drive_last_test",uvm_component parent = null);
			super.new(name,parent);
		endfunction

		task run_phase(uvm_phase phase);
			sequence6 seq;
			phase.raise_objection(this);
			seq=sequence6::type_id::create("seq");
			seq.start(e.act_agt.seqr);
			phase.drop_objection(this);
			phase.phase_done.set_drain_time(this,1100000);
		endtask

		virtual function void end_of_elaboration();
			print();
		endfunction

endclass

class regression_test extends test;

		`uvm_component_utils(regression_test)
    
		function new(string name = "regression_test",uvm_component parent = null);
    	super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
      regression_seq seq;
      phase.raise_objection(this);
      seq = regression_seq::type_id::create("seq");
      seq.start(e.act_agt.seqr);
      phase.drop_objection(this);
			phase.phase_done.set_drain_time(this,6000000);
    endtask

    virtual function void end_of_elaboration();
      print();
    endfunction	
endclass



