`ifndef DRIVER_SV
`define DRIVER_SV

class fifo_driver;
	virtual fifo_if vif;
    mailbox #(transaction) gen_to_drv;
    transaction tr;

  function new(virtual fifo_if vif, mailbox #(transaction) gen_to_drv);
        this.vif = vif;
        this.gen_to_drv = gen_to_drv;
    endfunction

    task run();
        wait(vif.rst_n == 1);
        forever begin
            gen_to_drv.get(tr);
            @(posedge vif.clk);
            #1;
            vif.w_en = tr.w_en;
            vif.r_en = tr.r_en;
            vif.data_in = tr.data_in;
        end
    endtask
endclass

`endif