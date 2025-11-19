`include "../design/top_axis_uart.v"

module top;
    
    bit clk,rst,axis_last,axis_valid,uart_tx,rx_valid,m_axis_ready;
    logic [7:0] axis_data, rx_data;

    
    top_axis_uart DUT(clk,rst,axis_data,axis_valid,axis_last,uart_tx,rx_valid,m_axis_ready,rx_data);

    initial begin
          clk = 1'b0;
          forever #10 clk = ~clk;
        end

    initial begin
          $dumpfile("wave.vcd");
          $dumpvars;
    end

    initial begin
      rst = 1;#20;
      rst = 0;axis_valid = 1;axis_last = 0;axis_data  = 10; #20;
      axis_data = 20;#20;
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
      axis_data = 20;#20; 
#100000


    end
endmodule

