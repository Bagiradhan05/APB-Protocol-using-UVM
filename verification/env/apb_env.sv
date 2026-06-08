//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb environment
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_ENV
`define _APB_ENV
class apb_env extends uvm_env;

// handle for agent,scoreboard and coverage and factory registraction 
   apb_agent agent_h;
   apb_scoreboard scoreboard_h;
   apb_coverage cov_h;
   `uvm_component_utils(apb_env)

//  constructor for enivironment
   function new(string name="apb_env",uvm_component parent=null);
      super.new(name,parent);
   `uvm_info(get_type_name(),"new construct of env",UVM_LOW);
   endfunction:new

//  build_phase for environment and memory creation for scoreboard,coverageand agent
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"before memory creation of env",UVM_LOW);
      scoreboard_h=apb_scoreboard::type_id::create("scoreboard_h",this);
      cov_h=apb_coverage::type_id::create("cov_h",this);
      agent_h=apb_agent::type_id::create("agent_h",this);
   endfunction:build_phase

//  connect phase for environment and connecting the monitor to scoreboard and coverage through the analyis port
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent_h.monitor_h.mon_port.connect(scoreboard_h.ap_sb);
      agent_h.monitor_h.mon_port.connect(cov_h.cov_imp);
   endfunction:connect_phase
endclass:apb_env

`endif
