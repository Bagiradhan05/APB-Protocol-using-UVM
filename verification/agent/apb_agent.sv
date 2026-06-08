//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol 
// Description:This file is implements the apb agent
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_AGENT
`define _APB_AGENT

class apb_agent extends uvm_agent;

   //handle assignment for sequencer,driver,monitor 
   apb_sequencer sequencer_h;
   apb_driver driver_h;
   apb_monitor monitor_h;
   //factory registration
   `uvm_component_utils(apb_agent)

   //constructor for apb_agent
   function new(string name ="apb_agent",uvm_component parent=null);
      super.new(name,parent);
   `uvm_info(get_type_name(),"constructor of agent",UVM_LOW);
   endfunction:new

   //build_phase for apb_agent
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"BEFORE memory creation for sequencer,driver,monitor",UVM_LOW);

      //memory creation for sequencer,driver,monitor
      sequencer_h=apb_sequencer::type_id::create("sequencer_h",this);
      driver_h=apb_driver::type_id::create("driver_h",this);
      monitor_h=apb_monitor::type_id::create("monitor_h",this);
   endfunction:build_phase

   //connect_phase for apb_agent
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      //connection between driver driver and sequencer using inbuild port
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
   endfunction:connect_phase

endclass:apb_agent

`endif
