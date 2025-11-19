`include "defines.sv"
`include "../design/top_axis_uart.v"
`include "interface.sv"

`include "../coverage/assertions.sv"
import uvm_pkg::*;
import pkg::*;


module top;
	
	bit clk;//,rst;

	intf vif(clk);//,rst);

  top_axis_uart DUT(clk,vif.rst,vif.axis_data,vif.axis_valid,vif.axis_last,vif.uart_tx,vif.rx_valid,vif.m_axis_ready,vif.rx_data);

	//bind vif assertions inst(clk,vif.rst,vif.axis_data,vif.axis_valid,vif.axis_last,vif.uart_tx,vif.rx_valid,vif.m_axis_ready,vif.rx_data); 
  
  always #10 clk = ~clk;
	initial begin
    //rst = 1;
    //#20;rst = 0;
	end

	initial begin
		uvm_config_db#(virtual intf)::set(null,"*","vif",vif);
	end
	initial begin
		//run_test("test2");
		//run_test("reset_test");
		//run_test("fifo_full_test");
		//run_test("valid_last_test"); 
		//run_test("drive_last_test"); // test not accepting inputs after axis_last is asserted waveform taken
		//run_test("data_drive_test"); // one data mismatch in m_axis_ready may be bug checked and waveform taken 
		run_test("regression_test"); // not running as only first ssequence is running in this test
	end

endmodule
