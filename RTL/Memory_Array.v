module Memory_Array #( 
parameter DATASIZE = 8, 
parameter DEPTH = 16, 
parameter PTR_WIDTH = $clog2(DEPTH) 
)( 
input wire clk,
input wire fifo_w_en, fifo_r_en, 
input wire [PTR_WIDTH:0] w_ptr, r_ptr, 
input wire [DATASIZE-1:0] data_in, 
output reg [DATASIZE-1:0] data_out); 
  
  reg [DATASIZE-1:0] mem_array [0:DEPTH-1]; 
always @(posedge clk) begin 
        if (fifo_w_en) mem_array [w_ptr[PTR_WIDTH-1:0]] <= data_in; 
        if (fifo_r_en) data_out <= mem_array [r_ptr[PTR_WIDTH-1:0]]; 
end 
endmodule