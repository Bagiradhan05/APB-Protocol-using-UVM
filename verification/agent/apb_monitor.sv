//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb monitor
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_MONITOR
`define _APB_MONITOR

class apb_monitor extends uvm_monitor;

//   declare transaction handle,virtual interface and factory registraction for apb monitor
   apb_transaction transaction_h;
   virtual apb_interface vif;
   int waitcount;
   `uvm_component_utils(apb_monitor)
//  declaring the analysid port for communicte between the scoreboard and coverage
   uvm_analysis_port#(apb_transaction)mon_port;

// constructor for apb monitor   
   function new(string name="apb_monitor",uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"constructor for monitor",UVM_LOW);
   endfunction:new

//  build phase for apb monitor
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//creating memory for analysis port      
      mon_port=new("mod_port",this);
      `uvm_info(get_type_name(),"inside moniotr build phase",UVM_LOW);
      if(!uvm_config_db#(virtual apb_interface)::get(this," ","vif",vif))
         `uvm_fatal(get_type_name(),"virtual interface is not found");
   endfunction:build_phase

//  run phase for apb monitor   
   task run_phase(uvm_phase phase);
      forever begin
         @(vif.monitor_cb);
         if(vif.monitor_cb.psel&&vif.monitor_cb.penable)begin
            transaction_h=new();
         while(!vif.monitor_cb.pready)begin
            waitcount++;
            @(vif.monitor_cb);
         end
         if(waitcount>5)
            `uvm_fatal(get_type_name(),$sformatf("wait count reached maximum %0d",waitcount));
         waitcount=0;

// receving the data from the dut monitoring the transation data
            transaction_h.paddr=vif.monitor_cb.paddr;
            transaction_h.pwdata=vif.monitor_cb.pwdata;
            transaction_h.pwrite=vif.monitor_cb.pwrite;
            transaction_h.prdata=vif.monitor_cb.prdata;
            transaction_h.pslverr=vif.monitor_cb.pslverr;
//  writing transaction data for accessing same transaction in scoreboard and coverage
            mon_port.write(transaction_h);
         end
         else
            @(vif.monitor_cb);
      end
   endtask:run_phase
endclass:apb_monitor

`endif
