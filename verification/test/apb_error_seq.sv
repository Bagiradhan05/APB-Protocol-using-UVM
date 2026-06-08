//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb error test sequence
// Date       :04/03/2026
//
//***************************************//

`ifndef _APB_ERROR_SEQ
`define _APB_ERROR_SEQ
class apb_error_seq extends uvm_sequence#(apb_transaction);

// declaring handle transaction for request,response and factory registraction   
   apb_transaction transaction_req_h;
   apb_transaction transaction_res_h;
   `uvm_object_utils_begin(apb_error_seq)
   `uvm_field_object(transaction_req_h,UVM_DEFAULT)
   `uvm_object_utils_end
// it is control, how numeber of transaction can generate that control ability in command line   
   int number_of_transaction;

// constructor for the apb error seq   
   function new(string name="apb_error_seq");
      super.new(name);
   endfunction:new

// main task for the error sequence execution   
   task body();
      transaction_res_h=apb_transaction::type_id::create("transaction_res_h");
      `uvm_info(get_type_name(),"created memroy for transaction_res ",UVM_LOW);
     if ($value$plusargs("number_of_transaction=%0d",number_of_transaction))
        number_of_transaction=number_of_transaction;
     else
        number_of_transaction = 10;

      repeat(number_of_transaction)begin
         
// creating memory for  request transaction         
         transaction_req_h=apb_transaction::type_id::create("transaction_req_h");
         `uvm_info(get_type_name(),"before start item ",UVM_LOW);
         start_item(transaction_req_h);
         `uvm_info(get_type_name(),"after start item ",UVM_LOW);

// transaction is receiving from driver that transaction should be send to driver or randomization transation data is send to driver.         
         if(transaction_res_h.flag==1)begin
            transaction_res_h.flag=0;
            transaction_req_h.copy(transaction_res_h);
            `uvm_info("debug",$sformatf("response data passing to driver=%0s",transaction_req_h.sprint()) ,UVM_LOW);
         end
         
         else begin
            `uvm_info(get_type_name(),"before randomization ",UVM_LOW);
            transaction_req_h.paddr=32'hffff_ffff;
//            transaction_req_h.randomize()with{pwrite==0;paddr==32'hffff_ffff;};
            `uvm_info("debug",$sformatf("randomization data passing to driver =%0s",transaction_req_h.sprint()) ,UVM_LOW);
         end
         `uvm_info(get_type_name(),"before finish item ",UVM_LOW);
         finish_item(transaction_req_h);
         `uvm_info(get_type_name(),"after finish item ",UVM_LOW);

// here every transaction receving response from driver         
         get_response(transaction_res_h);
         `uvm_info("res debug",$sformatf("get response data=%0s",transaction_res_h.sprint()) ,UVM_LOW);
      end
   endtask:body

endclass:apb_error_seq
`endif
