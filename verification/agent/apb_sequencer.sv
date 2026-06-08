//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb driver
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_SEQUENCER
`define _APB_SEQUENCER
class apb_sequencer extends uvm_sequencer#(apb_transaction);
  
//  factory registraction    
   `uvm_component_utils(apb_sequencer)

// constructor for apb sequencer   
   function new(string name="apb_sequencer",uvm_component parent=null);
      super.new(name,parent);
   `uvm_info(get_type_name(),"constructor for apb_sequencer",UVM_LOW);
   endfunction:new
   
endclass:apb_sequencer
`endif
