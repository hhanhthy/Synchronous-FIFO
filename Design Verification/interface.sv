`ifndef INTERFACE_SV
`define INTERFACE_SV

interface fifo_if #(parameter DATASIZE = 8)
                   (input bit clk, input bit rst_n);
  logic w_en;
  logic r_en;
  logic [DATASIZE-1:0] data_in;
  logic [DATASIZE-1:0] data_out;
  logic fifo_full;
  logic fifo_empty;
  logic fifo_overflow_flag;
  logic fifo_underflow_flag;
endinterface

`endif