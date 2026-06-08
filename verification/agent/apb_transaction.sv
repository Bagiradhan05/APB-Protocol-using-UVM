//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb transcation
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_TRANSACTION
`define _APB_TRANSACTION

class apb_transaction extends uvm_sequence_item;

   //control signal
        bit       psel;
        bit       penable;
        bit       pready;

   //side band siganls only randomizing the paddr,pwrite,pwdata
   rand bit [31:0]paddr;
   rand bit       pwrite;
   rand bit [31:0]pwdata;
        bit [31:0]prdata;
        bit       pslverr;

        bit flag;

        `uvm_object_utils_begin(apb_transaction)
        `uvm_field_int(psel,UVM_DEFAULT)
        `uvm_field_int(penable,UVM_DEFAULT)
        `uvm_field_int(pready,UVM_DEFAULT)
        `uvm_field_int(paddr,UVM_DEFAULT)
        `uvm_field_int(pwrite,UVM_DEFAULT)
        `uvm_field_int(pwdata,UVM_DEFAULT)
        `uvm_field_int(prdata,UVM_DEFAULT)
        `uvm_field_int(pslverr,UVM_DEFAULT)
        `uvm_field_int(flag,UVM_DEFAULT)
        `uvm_object_utils_end

        function new(string name="apb_transaction");
           super.new(name);
        endfunction:new
// assigning constraint for the paddr and pwdata understanding pupsoe giving the limites range values
        constraint c_paddr{paddr inside{[13:30]};}
        constraint c_pwdata{pwdata inside{[1:10]};}

endclass:apb_transaction

`endif
