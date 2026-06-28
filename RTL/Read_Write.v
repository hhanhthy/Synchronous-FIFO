module Write_pointer #(
    parameter DATASIZE = 8, 
    parameter DEPTH = 16, 
    parameter PTR_WIDTH = $clog2(DEPTH)
)(
    input wire clk, rst_n, 
    input wire w_en, fifo_full, 
    output reg [PTR_WIDTH:0] w_ptr, 
    output wire fifo_w_en
);
assign fifo_w_en = (w_en & !fifo_full);
always @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        w_ptr <= 0;
    end else
        if(fifo_w_en)begin 
            w_ptr <= w_ptr +1'b1;
        end 
end
endmodule

module Read_pointer #(
    parameter DATASIZE = 8, 
    parameter DEPTH = 16, 
    parameter PTR_WIDTH = $clog2(DEPTH)
)(
    input wire clk, rst_n, 
    input wire r_en, fifo_empty, 
    output reg [PTR_WIDTH:0] r_ptr, 
    output wire fifo_r_en
);
assign fifo_r_en = (r_en & !fifo_empty);
always @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        r_ptr <= 0;
    end else begin 
        if(fifo_r_en)begin 
            r_ptr <= r_ptr +1'b1;
        end 
    end
end
endmodule