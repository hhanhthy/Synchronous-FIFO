`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

module tb_top;
    bit clk;
    bit rst_n;
    initial clk = 0;
    always #5 clk = ~clk;
    fifo_if #(.DATASIZE(8)) vif(clk, rst_n);
    Synchronous_FIFO_memory #(.DATASIZE(8), .DEPTH(16), .PTR_WIDTH(4)) dut (
      .clk(vif.clk), .rst_n (vif.rst_n), .w_en (vif.w_en),
      .r_en (vif.r_en), .data_in (vif.data_in),.data_out(vif.data_out),
      .fifo_full (vif.fifo_full), .fifo_empty(vif.fifo_empty),
      .fifo_overflow_flag(vif.fifo_overflow_flag),
      .fifo_underflow_flag(vif.fifo_underflow_flag));

    initial begin
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);
    end
    initial begin
        mailbox #(transaction) gen_to_drv = new();
        mailbox #(transaction) mon_to_sb  = new();
        fifo_generator gen = new(gen_to_drv);
        fifo_driver drv = new(vif, gen_to_drv);
        fifo_monitor mon = new(vif, mon_to_sb);
        fifo_scoreboard sb = new(mon_to_sb);
        gen.count = 50;
        wait(rst_n == 1);
        repeat(2) @(posedge clk);
        fork
            gen.run();
            drv.run();
            mon.run();
            sb.run();
        join_any
        repeat(20) @(posedge clk);
        $display("PASS: %0d | FAIL: %0d", sb.pass_cnt, sb.fail_cnt);
        $finish;
    end
endmodule