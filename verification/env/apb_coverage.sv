//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb coverage
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_COVERAGE
`define _APB_COVERAGE

class apb_coverage extends uvm_subscriber#(apb_transaction);
   
//   handle assignment for transaction and factory registration 
   apb_transaction transaction_h;
   `uvm_component_utils(apb_coverage)

//   declaring analysis port access the output in scoreboard and coverage through this analysis port
   uvm_analysis_imp#(apb_transaction,apb_coverage)cov_imp;
//  constructor for coverage 
   function new(string name="apb_coverage",uvm_component parent=null);
      super.new(name,parent);
//      creating memory for covergroup 
      apb_cg=new();
   endfunction:new

//  build_phase for coverage
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
//    creating mermory for analysis imp 
      cov_imp=new("cov_imp",this);
   endfunction:build_phase


//   coverage to check percentage of function coverage and code coverage
   covergroup apb_cg;

//      paddr -->just creating bins for understanding purpose give small range of paddr.we are creating here illegal bins because in design some external feature are there in particular address so can't able to access that paddr
      PADDR:coverpoint transaction_h.paddr
      {
         bins using[]={[13:30]};
         ignore_bins ig_s={[31:255]};
         illegal_bins il_s={0,4,8,12};
         bins error_occur={32'hffff_ffff};
      }

//      pwdata create array of bins 1 to 10.It create only 10 bins,for understanding for we are giving limited range
      PWDATA:coverpoint transaction_h.pwdata
      {
         bins data[]={[1:10]};
      }

//  pwrite can hit the pwrite is 1 write operation is excuted and pwrite is 0 read operation is executes
      PWRITE:coverpoint transaction_h.pwrite
      { 
         bins read={0};
         bins write={1};
      }

//  psel can hit on or off
      PSEL:coverpoint transaction_h.psel 
      { 
         bins psel_on={1};
         bins psel_off={0};
      }

//  penable can hit on or off
      PENABLE:coverpoint transaction_h.penable
      { 
         bins en_on={1};
         bins en_off={0};
      }
      
//  pready can hit on or off
      PREADY:coverpoint transaction_h.pready
      { 
         bins wait_state={1};
         bins no_wait_state={0};
      }

//   cross paddr and pwrite
      cross_1:cross PADDR,PWRITE;
//   cross paddr pwdata
      cross_2:cross PADDR,PWDATA;
   endgroup

//  write operation for access the output received from monitor using analysis port
   function void write(apb_transaction t);
      transaction_h=t;
//  sample data,it is check data is hit or not
      apb_cg.sample();
   endfunction:write

endclass:apb_coverage
`endif
