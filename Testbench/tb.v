`timescale 1ns/1ps
module tb_sync_fifo;
  parameter DATASIZE = 8;
  parameter DEPTH    = 16;
  reg clk;
  reg rst_n;
  reg w_en, r_en;
  reg [DATASIZE-1:0] data_in;
  wire [DATASIZE-1:0] data_out;
  wire fifo_full, fifo_empty;
  wire fifo_overflow_flag, fifo_underflow_flag;
 
  Synchronous_FIFO_memory dut (.clk(clk), .rst_n(rst_n), .w_en(w_en),
                               .r_en(r_en),.data_in(data_in),.data_out(data_out),
                               .fifo_full(fifo_full),.fifo_empty(fifo_empty),
                               .fifo_overflow_flag(fifo_overflow_flag),
                               .fifo_underflow_flag(fifo_underflow_flag));
  initial clk = 0;
  always #5 clk = ~clk;
  initial begin
    $dumpfile("tb_sync_fifo.vcd");
    $dumpvars(0, tb_sync_fifo);
  end
  
  initial begin
    $monitor(" TIME %4t| W  %b R %b | IN  %02h| OUT %02h | FULL %b EMPTY %b| OVF %b UDF %b", $time, w_en, r_en, data_in, data_out, fifo_full, fifo_empty,
              fifo_overflow_flag, fifo_underflow_flag);
  end
  task write_data(input [7:0] d);
  begin
    @(negedge clk);
    w_en = 1;
    data_in = d;
    @(negedge clk);
    w_en = 0;
  end
  endtask
  task read_data;
  begin
    @(negedge clk);
    r_en = 1;
    @(negedge clk);
    r_en = 0;
  end
  endtask
  initial begin
    // init
    rst_n = 0;
    w_en  = 0;
    r_en  = 0;
    data_in = 0;
    repeat(3) @(negedge clk);
    rst_n = 1;
   
    $display("\n===== NORMAL WRITE =====");
    write_data(8'h11);
    write_data(8'h22);
    write_data(8'h33);
    write_data(8'h44);
  
    $display("\n===== NORMAL READ =====");
    read_data();
    read_data();
    $display("\n===== SIMULTANEOUS R/W =====");
    @(negedge clk);
    w_en = 1;
    r_en = 1;
    data_in = 8'hAA;
    @(negedge clk);
    w_en = 0;
    r_en = 0;
    $display("\n===== RESET MID TEST =====");
    write_data(8'h55);
    write_data(8'h66);
    write_data(8'h77);
    @(negedge clk);
    rst_n = 0;
    @(negedge clk);
    rst_n = 1;
    if (fifo_empty)
      $display("PASS");
    else
      $display("ERROR");
    read_data();
 
    $display("\n===== FILL FIFO =====");
    repeat (DEPTH) write_data($random);
  
    $display("\n===== OVERFLOW TEST =====");
    write_data(8'hFF);
    @(posedge clk);
    if (fifo_overflow_flag)
      $display("PASS");
    else
      $display("ERROR");
    $display("\n===== EMPTY FIFO =====");
    repeat (DEPTH) read_data();
  
    $display("\n===== UNDERFLOW TEST =====");
    read_data();
    @(posedge clk);
    if (fifo_underflow_flag)
      $display("PASS");
    else
      $display("ERROR");
    #40;
    $finish;
  end
endmodule
