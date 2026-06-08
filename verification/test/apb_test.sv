//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb test
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_TEST
`define _APB_TEST

class apb_test extends uvm_test;

// declaring the handle for apb_read_seq,apb_write_seq,apb_wr_seq,apb_erroe_seq,env and factory registration   
   apb_read_seq apb_read_seq_h;
   apb_write_seq apb_write_seq_h;
   apb_wr_seq apb_wr_seq_h;
   apb_error_seq apb_error_seq_h;
   apb_env env_h;
   `uvm_component_utils(apb_test)

// constructor for apb test   
   function new(string name="apb_test",uvm_component parent=null);
      super.new(name,parent);
   `uvm_info(get_type_name(),"inside the function new of apb_test ",UVM_LOW);
   endfunction:new

// build phase for apb test and memory creation env
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"before creating memory for env",UVM_LOW);
      env_h=apb_env::type_id::create("env_h",this);
   endfunction:build_phase

// main task for apb test   
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      apb_read_seq_h=apb_read_seq::type_id::create("apb_read_seq_h");
      apb_write_seq_h=apb_write_seq::type_id::create("apb_write_seq_h");
      apb_wr_seq_h=apb_wr_seq::type_id::create("apb_wr_seq_h");
      apb_error_seq_h=apb_error_seq::type_id::create("apb_error_seq_h");
      `uvm_info("read_seq","-----------------------------------",UVM_NONE);
      `uvm_info("read_seq","-------------read test--------------",UVM_NONE);
      apb_read_seq_h.start(env_h.agent_h.sequencer_h);
      `uvm_info("write_seq","-----------------------------------",UVM_NONE);
      `uvm_info("write_seq","------------write test--------------",UVM_NONE);
      apb_write_seq_h.start(env_h.agent_h.sequencer_h);
      `uvm_info("wr_seq","-----------------------------------",UVM_NONE);
      `uvm_info("wr_seq","------------read and write test--------------",UVM_NONE);
      apb_wr_seq_h.start(env_h.agent_h.sequencer_h);
      `uvm_info("error_seq","-----------------------------------",UVM_NONE);
      `uvm_info("error_seq","------------error test--------------",UVM_NONE);
      apb_error_seq_h.start(env_h.agent_h.sequencer_h);
      phase.drop_objection(this);
   endtask:run_phase

endclass:apb_test
`endif
