`ifndef MONITOR_SV
`define MONITOR_SV

class fifo_monitor;
    virtual fifo_if vif;
    mailbox #(transaction) mon_to_sb;
    transaction tr;

    function new(virtual fifo_if vif,
                 mailbox #(transaction) mon_to_sb);
        this.vif       = vif;
        this.mon_to_sb = mon_to_sb;
    endfunction

    task run();
        wait(vif.rst_n == 1);
        forever begin
            @(posedge vif.clk);
            #2;
            tr = new();
            tr.w_en = vif.w_en;
            tr.r_en = vif.r_en;
            tr.data_in = vif.data_in;
            tr.fifo_full = vif.fifo_full;
            tr.fifo_empty = vif.fifo_empty;
            tr.fifo_overflow_flag = vif.fifo_overflow_flag;
            tr.fifo_underflow_flag= vif.fifo_underflow_flag;

            if      (tr.w_en) tr.tr_type = "WRITE";
            else if (tr.r_en) tr.tr_type = "READ";
            else              tr.tr_type = "IDLE";
            if (tr.r_en && !tr.fifo_empty) begin
                @(posedge vif.clk);
                #2;
                tr.data_out = vif.data_out;
            end
            if (tr.w_en || tr.r_en)
                mon_to_sb.put(tr);
        end
    endtask

endclass

`endif