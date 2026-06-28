module Synchronous_FIFO_memory #(
    parameter DATASIZE = 8, 
    parameter DEPTH = 16, 
    parameter PTR_WIDTH = $clog2(DEPTH)
)(
    input wire  clk, 
    input wire  rst_n, 
    input wire  w_en, 
    input wire  r_en, 
    input wire [DATASIZE-1:0] data_in, 
    output wire [DATASIZE-1:0] data_out, 
    output wire     fifo_full, 
    output wire     fifo_empty, 
    output wire     fifo_overflow_flag, 
    output wire     fifo_underflow_flag
);
    wire [PTR_WIDTH:0] w_ptr, r_ptr; 
    wire fifo_w_en, fifo_r_en; 
    
    Write_pointer #(.DATASIZE(DATASIZE), .DEPTH(DEPTH), .PTR_WIDTH(PTR_WIDTH)) u_write_ptr (
    .w_en(w_en), 
    .fifo_full(fifo_full),
    .clk(clk), 
    .rst_n(rst_n), 
    .fifo_w_en(fifo_w_en), 
    .w_ptr(w_ptr)
);
    Read_pointer #(.DATASIZE(DATASIZE), .DEPTH(DEPTH), .PTR_WIDTH(PTR_WIDTH)) u_read_ptr (
    .r_en(r_en), 
    .fifo_empty(fifo_empty),
    .clk(clk), 
    .rst_n(rst_n), 
    .fifo_r_en(fifo_r_en), 
    .r_ptr(r_ptr)
);
    Memory_Array #(.DATASIZE(DATASIZE), .DEPTH(DEPTH), .PTR_WIDTH(PTR_WIDTH)) u_mem (
    .clk(clk), 
    .fifo_w_en(fifo_w_en),
    .w_ptr(w_ptr), 
    .r_ptr(r_ptr), 
    .data_in(data_in),
    .fifo_r_en(fifo_r_en), 
    .data_out(data_out)
);
    Memory_State #(.DATASIZE(DATASIZE), .DEPTH(DEPTH), .PTR_WIDTH(PTR_WIDTH)) u_state (
    .clk(clk), 
    .rst_n(rst_n),
    .w_en(w_en), 
    .r_en(r_en), 
    .w_ptr(w_ptr), 
    .r_ptr(r_ptr), 
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_overflow_flag(fifo_overflow_flag),
    .fifo_underflow_flag(fifo_underflow_flag)
);
endmodule
    

