`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class fifo_scoreboard;
    mailbox #(transaction) mon_to_sb;
    transaction tr;
    bit [7:0] ref_fifo[$];
    int pass_cnt = 0;
    int fail_cnt = 0;

    function new(mailbox #(transaction) mon_to_sb);
        this.mon_to_sb = mon_to_sb;
    endfunction

    task run();
        forever begin
            mon_to_sb.get(tr);
            if (tr.tr_type == "WRITE") begin
                if (!tr.fifo_full)
                    ref_fifo.push_back(tr.data_in);
            end else if (tr.tr_type == "READ") begin
                if (!tr.fifo_empty && ref_fifo.size() > 0) begin
                    bit [7:0] expected = ref_fifo.pop_front();
                    if (expected == tr.data_out) begin
                        $display("PASS");
                        pass_cnt++;
                    end else begin
                        $display("FAIL: expected=%0d got=%0d", expected, tr.data_out);
                        fail_cnt++;
                    end
                end
            end
        end
    endtask
endclass

`endif