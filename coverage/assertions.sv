module assertions(
  input clk, rst,
  input [7:0] axis_data,
  input axis_valid, axis_last,
  input m_axis_ready, uart_tx,
  input rx_valid,
  input [7:0] rx_data
);
  
  property rst_check;
    @(posedge clk) rst |-> (m_axis_ready == 0);
  endproperty
  ASSERT_RST_CHECK: assert property (rst_check);
  
  property fifo_ready_check;
    @(posedge clk) disable iff (rst)
    (axis_valid && !m_axis_ready) |=> (axis_valid && !m_axis_ready)[*1:$] ##0 m_axis_ready;
  endproperty
  ASSERT_FIFO_READY: assert property (fifo_ready_check);
  
  property valid_one_cycle;
    @(posedge clk) disable iff (rst)
    $rose(rx_valid) |-> (rx_valid [*1]) ##0 !rx_valid;
  endproperty
  ASSERT_VALID_ONE_CYCLE: assert property (valid_one_cycle);
  
endmodule
