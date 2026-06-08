//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb scoreboard
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_SCOREBOARD
`define _APB_SCOREBOARD

class apb_scoreboard extends uvm_scoreboard;

// declaring the handle for transaction, local memory,virtual interface and factory registraction   
   apb_transaction transaction_h;
   bit[31:0] mem[bit[31:0]];
   virtual apb_interface vif;
   `uvm_component_utils(apb_scoreboard)

// declaring the analysis imp for accessing the executeda data in monitor   
   uvm_analysis_imp#(apb_transaction,apb_scoreboard)ap_sb;

// this is constructor for apb_scorebaord   
   function new(string name="apb_scoreboard",uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"constructor for scoreboard",UVM_LOW);
   endfunction:new

// this is buils phase for apb_scoreboars and creating memory for analysis imp
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      ap_sb=new("ap_sb",this);
   endfunction:build_phase

//  accessing the transaction data here   
   function void write(apb_transaction transaction_h);
      `uvm_info(get_type_name(),"received packet inside scoreboard",UVM_LOW);
 
//  checking the pslverr      
      if(transaction_h.pslverr)begin
         `uvm_error(get_type_name(),$sformatf("slave error paddr=%0h pslverr=%0d pwrite=%0b",transaction_h.paddr,transaction_h.pslverr,transaction_h.pwrite));
         return;
      end

//  write operation is executed inside local memory we can write data in same address line 
      if(transaction_h.pwrite)begin
         mem[transaction_h.paddr]=transaction_h.pwdata;
         `uvm_info(get_type_name(),$sformatf("write data mem[%0h]=%0h",transaction_h.paddr,transaction_h.pwdata),UVM_LOW);
      end

// read operation is executed, it is checking address is exists or not if exists means pass or fail can idendtify the transaction and if not exists means uninitialized address we are accessing.      
      else begin
         if(!mem.exists(transaction_h.paddr))begin
            `uvm_warning(get_type_name(),$sformatf("read from uninitialized paddr=%0h",transaction_h.paddr));
            return;
         end
         if(mem[transaction_h.paddr]==transaction_h.prdata)begin
         `uvm_info(get_type_name(),$sformatf("PASS paddr=%0h mem=%0h prdata=%0h",transaction_h.paddr,mem[transaction_h.paddr],transaction_h.prdata),UVM_LOW);
         end
         else begin
         `uvm_info(get_type_name(),$sformatf("FAIL paddr=%0h mem=%0h prdata=%0h",transaction_h.paddr,mem[transaction_h.paddr],transaction_h.prdata),UVM_LOW);
         end
      end
   endfunction:write
   
endclass:apb_scoreboard

`endif
