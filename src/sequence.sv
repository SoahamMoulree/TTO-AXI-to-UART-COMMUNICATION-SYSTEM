class base_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(base_sequence)

	function new(string name = "base_sequence");
		super.new(name);
	endfunction

	task body();
		repeat(`num_of_txns) begin
			req = seq_item::type_id::create("req");
      start_item(req);
      count++;
		  req.randomize();// with {req.axis_valid == 1;};      
			$display("Sequence @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last);
		  finish_item(req);
    end
	endtask
endclass

class sequence2 extends uvm_sequence#(seq_item);
  `uvm_object_utils(sequence2)
  function new(string name = "sequence2");
    super.new(name);
  endfunction

  task body();
    seq_item req;

		req = seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { rst == 1;});
    `uvm_info("SEQUENCE2",$sformatf("________ASSERTING RST __________ @(%0t) rst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
    finish_item(req);

    for(int i=0; i< (`num_of_txns/2) - 1; i++)begin
      req = seq_item::type_id::create("req");
      start_item(req);
						assert(req.randomize() with { axis_last == 0;axis_valid == 1;rst == 0;});
      `uvm_info("SEQUENCE2",$sformatf("@(%0t)\n | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
      finish_item(req);
    end

    req = seq_item::type_id::create("req");
    start_item(req);
					assert(req.randomize() with {axis_last == 0; axis_valid == 0;rst == 0;});
    `uvm_info("SEQUENCE2",$sformatf("________DEASSERTING AXIS_VALID__________ IN MIDDLE @(%0t) | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
    finish_item(req);

    for(int i=(`num_of_txns/2); i<`num_of_txns; i++)begin
      req = seq_item::type_id::create("req");
      start_item(req);
						assert(req.randomize() with {  axis_valid == 1;rst == 0;axis_last == 0;});
      `uvm_info("SEQUENCE1",$sformatf(" @(%0t)| axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
      finish_item(req);
    end
  endtask
endclass

class sequence1 extends base_sequence;
   `uvm_object_utils(sequence1)

   function new(string name = "sequence1");
     super.new(name);
   endfunction

   task body();
     seq_item req;

     req = seq_item::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {rst == 1;axis_valid == 1;});
     `uvm_info("SEQUENCE1",$sformatf("____APPLYING REST @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
     finish_item(req);

     for(int i=1; i< (`num_of_txns/2) - 1; i++)begin
       req = seq_item::type_id::create("req");
       start_item(req);
						 assert(req.randomize() with { rst == 0 ;axis_valid == 1;axis_last == 0;});
       `uvm_info("SEQUENCE1",$sformatf("____DEASSERTING RESET @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
       finish_item(req);
     end
		 req = seq_item::type_id::create("req");
     start_item(req);
     assert(req.randomize() with {rst == 1 ; axis_valid == 1;});
     `uvm_info("SEQUENCE1",$sformatf("____APPLYING REST IN MIDDLE @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
     finish_item(req);

     for(int i=(`num_of_txns/2); i<`num_of_txns; i++)begin
       req = seq_item::type_id::create("req");
       start_item(req);
						 assert(req.randomize() with { rst == 0; axis_valid == 1;axis_last == 0;});
       `uvm_info("SEQUENCE1",$sformatf("____DEASSERTING RESET @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
       finish_item(req);
     end
   endtask
endclass


class sequence4 extends uvm_sequence#(seq_item);
   `uvm_object_utils(sequence4)
 
   function new(string name="sequence4");
      super.new(name);
   endfunction
 
   virtual task body();
 	   req=seq_item::type_id::create("req");
		  //req = seq_item::type_id::create("req");
			start_item(req);
     	assert(req.randomize() with {rst == 1;axis_valid == 1;});
     	`uvm_info("SEQUENCE1",$sformatf("____APPLYING REST @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
     	finish_item(req);

		 	repeat(8) `uvm_rand_send_with(req,{req.rst == 0;req.axis_valid==1;req.axis_last==0;})
   endtask
 
endclass
 
class sequence6 extends uvm_sequence#(seq_item);
    `uvm_object_utils(sequence6)
 
    function new(string name="sequence6");
       super.new(name);
    endfunction
 
    virtual task body();
      req=seq_item::type_id::create("req");
			start_item(req);
						assert(req.randomize() with {rst == 1;axis_valid == 1;axis_last == 0;});
			`uvm_info("SEQUENCE1",$sformatf("____APPLYING REST @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
			finish_item(req);
			repeat(2) `uvm_rand_send_with(req,{req.rst == 0;req.axis_valid == 1;req.axis_last == 0;})
			repeat(1) `uvm_rand_send_with(req,{req.rst == 0;req.axis_valid == 1;req.axis_last == 1;})
			repeat(3) `uvm_rand_send_with(req,{req.rst == 0;req.axis_valid == 1;req.axis_last == 0;})
			repeat(4) `uvm_rand_send_with(req,{req.rst == 0;req.axis_valid == 1;req.axis_last == 1;})
			repeat(3) `uvm_rand_send_with(req,{req.rst == 0;req.axis_valid == 1;req.axis_last == 0;})
    endtask
endclass
 
class sequence7 extends uvm_sequence#(seq_item);

    `uvm_object_utils(sequence7)
 
    function new(string name = "sequence7");
	    super.new(name);
    endfunction
 
    virtual task body();
      req = seq_item::type_id::create("req");
			 start_item(req);
			 assert(req.randomize() with {rst == 1;axis_valid == 1;axis_last == 1;});
			 `uvm_info("SEQUENCE1",$sformatf("____APPLYING REST @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
			 finish_item(req);	
			 repeat(5)`uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 1;});
			 repeat(5)`uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 0;});
    endtask
endclass
 

class sequence8 extends uvm_sequence#(seq_item);

    `uvm_object_utils(sequence8)
 
    function new(string name = "sequence8");
       super.new(name);
    endfunction
 
    virtual task body();
       repeat(5) begin
          req = seq_item::type_id::create("req");
					start_item(req);
					assert(req.randomize() with {rst == 1;axis_valid == 1;axis_last == 0;});
					`uvm_info("SEQUENCE1",$sformatf("____APPLYING REST @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
				  finish_item(req);
					start_item(req);
					repeat(10) begin
							req.rst = 'bx; 
							req.axis_valid = 1;
					 		req.axis_last = 0;
          		req.axis_data = 'bz;
					end
				  finish_item(req);
					start_item(req);
					repeat(10) begin
							req.rst = 'bx; 
							req.axis_valid = 1;
					 		req.axis_last = 1;
          		req.axis_data = 'bz;
					end
					`uvm_info("SEQUENCE1",$sformatf("____APPLYING REST @(%0t)\nrst = %0b | axis_data  =%0d | axis_valid = %0b | axis_last = %0b",$time,req.rst,req.axis_data,req.axis_valid,req.axis_last),UVM_LOW);
				  finish_item(req);
       end
    endtask
endclass
  

class sequence9 extends uvm_sequence#(seq_item);

  `uvm_object_utils(sequence9)

  function new(string name = "sequence9");
    super.new(name);
  endfunction

  virtual task body();
    req = seq_item::type_id::create("req");
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 0;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 1;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 0;axis_data == 'd0;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 0;axis_data == 'd255;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 0;axis_data == 'd170;});
    `uvm_rand_send_with(req, {req.rst == 0; req.axis_valid == 1;axis_last == 0;axis_data == 'd85;});
  endtask
endclass


class regression_seq extends uvm_sequence#(seq_item);

		`uvm_object_utils(regression_seq)
		base_sequence seq1;
		sequence1 seq2;
		sequence2 seq3;
		sequence4 seq4;
		sequence6 seq5;
		sequence7 seq6;
		sequence8 seq7;
		sequence9 seq8;
		//sequence2 seq3;


		function new(string name = "regression_seq");
			super.new(name);
		endfunction

		virtual task body();
			`uvm_do(seq7)
      `uvm_do(seq8)
			`uvm_do(seq2)
			`uvm_do(seq3)
			`uvm_do(seq4)
			`uvm_do(seq5)
			`uvm_do(seq6)
		endtask
endclass
 
