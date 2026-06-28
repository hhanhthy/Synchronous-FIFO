`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
    string tr_type;
    randc bit [7:0] data_in;
    rand  bit w_en;
    rand  bit r_en;
    bit [7:0] data_out;
    bit fifo_full;
    bit fifo_empty;
    bit fifo_overflow_flag;
    bit fifo_underflow_flag;
    constraint c1 {!(w_en && r_en);}
endclass

`endif