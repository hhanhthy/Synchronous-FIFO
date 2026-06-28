module Memory_State #(
    parameter DATASIZE = 8, 
    parameter DEPTH = 16, 
    parameter PTR_WIDTH = $clog2(DEPTH)
)(
    input wire clk, rst_n,
  	input wire w_en, r_en,
    input wire [PTR_WIDTH:0] w_ptr,r_ptr, 
    output wire fifo_empty, fifo_full, 
    output reg fifo_underflow_flag, fifo_overflow_flag
);
wire write_temp, read_temp; 
wire msb,lsb;
assign msb = (w_ptr [PTR_WIDTH] == r_ptr [PTR_WIDTH]); 
assign lsb = (w_ptr [PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0]);
assign fifo_empty = msb & lsb; 
assign fifo_full = !msb & lsb;
assign write_temp = fifo_full & w_en; 
assign read_temp = fifo_empty & r_en;
always@(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin 
        fifo_underflow_flag <= 0;
        fifo_overflow_flag <= 0; 
    end else begin 
        if(write_temp) fifo_overflow_flag <= 1'b1; 
        else fifo_overflow_flag <= 1'b0; 
        if (read_temp) fifo_underflow_flag <= 1'b1; 
        else fifo_underflow_flag <= 1'b0; 
    end 
end 
endmodule