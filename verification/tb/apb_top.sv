//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb top module
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_TOP
`define _APB_TOP
import uvm_pkg::*;
`include "uvm_macros.svh"
import apb_test_package::*;
//`include "apb_transaction.sv"
//`include "apb_sequence.sv"
//`include "apb_write_seq.sv"
//`include "apb_wr_seq.sv"
//`include "apb_error_seq.sv"
//`include "apb_sequencer.sv"
//`include "apb_driver.sv"
//`include "apb_monitor.sv"
//`include "apb_scoreboard.sv"
//`include "apb_coverage.sv"
//`include "apb_agent.sv"
//`include "apb_env.sv"
//`include "apb_test.sv"
//`include "apb_interface.sv"
//`include "apb_slave_design.sv"

module apb_top();

logic pclk;
logic presetn;
apb_interface intf(pclk,presetn);
apb_slave dut(intf);
always#5 pclk=~pclk;
initial begin
   pclk=0;
   presetn=0;
   #20;
   presetn=0;
   #20;presetn=1;
   #20;presetn=0;
   #20;presetn=1;
   #60;presetn=0;
   #50;presetn=1;
   #2500;$finish;
end
initial begin
   `uvm_info("apb_top","BEFORE calling run test",UVM_LOW);
   run_test("apb_test");
end
initial begin
   uvm_config_db#(virtual apb_interface)::set(null,"*","vif",intf);
end
endmodule:apb_top

`endif
