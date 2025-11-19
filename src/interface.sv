interface intf(input bit clk);//,rst);

	logic rst;
	logic [7:0] axis_data, rx_data;
	logic axis_valid, axis_last, m_axis_ready, uart_tx, rx_valid;

	clocking drv_cb@(posedge clk);
		default input #0 output #0;
		output rst,axis_data, axis_valid, axis_last;	
	endclocking

	clocking act_mon_cb@(posedge clk);
		default input #0 output #0;
		input  rst, axis_data, axis_valid, axis_last,m_axis_ready; 
	endclocking

	clocking pass_mon_cb@(posedge clk);
	  default input #0 output #0;
	  input  rx_data, rx_valid, uart_tx,m_axis_ready;
	endclocking
	
	modport DRIVER(clocking drv_cb);
	modport ACTIVE_MONITOR(clocking act_mon_cb);
	modport PASSIVE_MONITOR(clocking pass_mon_cb);

  /*property rst_check;
    @(posedge clk) rst |=> (m_axis_ready && (uart_tx == 0) && (rx_data == 0) && (rx_valid == 0));
  endproperty
  ASSERT_RST_CHECK: assert property (rst_check)
    $info("RST ASSERTION PASSED ALL OUTPUTS SET TO 0");
  else
    $error("RST ASSERTION FAILED ALL OUTPUTS NOT SET TO 0");
  
  /*property fifo_ready_check;
    @(posedge clk) disable iff (rst)
    (count == 8) |-> (m_axis_ready == 0);
  endproperty
  ASSERT_FIFO_READY: assert property (fifo_ready_check);
  /*
  property valid_one_cycle;
    @(posedge clk) disable iff (rst)
    $rose(rx_valid) |-> (rx_valid [*1]) ##0 !rx_valid;
  endproperty
  ASSERT_VALID_ONE_CYCLE: assert property (valid_one_cycle);
endinterface*/
   /* property p1;

      @(posedge clk) disable iff (rst)

      axis_valid |-> !$isisunknown(axis_data);

    endproperty

    assert property(p1)
    else $error("p1 failed: axis_data has isunknown values when axis_valid is high");
*/


    /*property p2;

      @(posedge clk) disable iff (!rst)

      ##4774 (rx_data == 0 && uart_tx == 0 && !rx_valid && m_axis_ready);

    endproperty

    assert property (p2)
    else $error("p2 failed: Signals not in expected state during rst");
*/




    /*property p3;

      @(posedge clk) disable iff (rst)

      axis_valid && !m_axis_ready |=> $stable(axis_data);

    endproperty

    assert property(p3)
    else $error("p3 failed: axis_data changed while axis_valid high and m_axis_ready low");
*/

    /*property p4;

      @(posedge clk) disable iff (rst)

      (rx_valid)|->##(10*434) (uart_tx == 1)|-> ##(434) $rose(rx_valid);

    endproperty

    assert property (p4) $display(" P4 PASS");
    else $error("p4 failed: uart_tx has isunknown values 4774 cycles after axis_valid");
*/
    property p7;

      @(posedge clk) disable iff (rst)

      (axis_valid && m_axis_ready) |-> ##434 (!$isunknown(uart_tx))[*11];

    endproperty

    assert property (p7) else $error("p4 failed: uart_tx not stable for 11 cycles starting 434 cycles after AXI transaction");

    property p5;

      @(posedge clk) disable iff (rst)

      axis_valid |-> ##4774 !$isunknown(rx_data);

    endproperty

    assert property (p5) else $error("p5 failed: rx_data has isunknown values 4774 cycles after axis_valid");




    property p6;

      @(posedge clk) disable iff (rst)

      rx_valid |-> !$isunknown(rx_data);

    endproperty
    assert property (p6) else $error("p6 failed: rx_data has isunknown values when rx_valid is high");
endinterface
