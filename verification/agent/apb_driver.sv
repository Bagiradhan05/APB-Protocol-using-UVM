//***************************************//
//
// Author     :BAGIRADHAN S
// e-mail     :bagiradhansrinivasan@gmail.com
// Project    :APB protocol
// Description:This file is implements the apb driver
// Date       :04/03/2026
//
//***************************************//


`ifndef _APB_DRIVER
`define _APB_DRIVER

class apb_driver extends uvm_driver#(apb_transaction);
   
//  Handle assignment for transaction request and response
   apb_transaction transaction_req_h;
   apb_transaction transaction_res_h;
//   Handshake between dut and driver through virtual interface
   virtual apb_interface vif;
//   To check the pready signal receving within 5 clk cycles or not
   int wait_count;
//   Factory registraction for driver
   `uvm_component_utils(apb_driver)

//   constructor for apd driver
   function new(string name="apb_driver",uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"constructor for driver",UVM_LOW);
   endfunction:new

//  Build phase for apb driver
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);      
      `uvm_info(get_type_name(),"inside driver build phase",UVM_LOW);
//   getting the signal using the config_db through virtual interface      
      if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
         `uvm_fatal(get_type_name(),"virtual interface is not found");
   endfunction:build_phase

//  run phase for driver   
   task run_phase(uvm_phase phase);
      forever begin
      seq_item_port.get_next_item(transaction_req_h);
      run();
      `uvm_info(get_type_name(),"before item done",UVM_LOW);
      seq_item_port.item_done();
      `uvm_info(get_type_name(),"after item done",UVM_LOW);
//  if reset occurs send that transaction to sequence or actual transaction should pass to sequence      
      if(transaction_res_h!=null&&transaction_res_h.flag==1)
         seq_item_port.put_response(transaction_res_h);
      else 
         seq_item_port.put_response(transaction_req_h);
   end
   endtask:run_phase

// this is main task for the apb driver
   task run();
      @(vif.master_cb);
// reset occurs means execute the reset logic,it can calculate the 1'bx and 1'bz    
      if(!vif.presetn||$isunknown(vif.presetn))begin
         reset_logic(transaction_req_h);
      end
// reset not occurs means execute the driver logic      
      else begin
         driver_logic(transaction_req_h);
      end

   endtask:run

// this is the reset logic    
   task reset_logic(apb_transaction transaction_req_h);
      `uvm_info("reset_occurs","inside reset_logic",UVM_LOW);
      do begin
      vif.paddr<=0;
      vif.pwrite<=0;
      vif.psel<=0;
      vif.penable<=0;
      vif.pwdata<=0;
      @(vif.master_cb);
   end
      while(!vif.presetn||$isunknown(vif.presetn));
      `uvm_info("reset_occurs","outside reset_logic",UVM_LOW);
   endtask:reset_logic

//  all states are excuted inside in driver logic
   task driver_logic(apb_transaction transaction_req_h);

//  initial this is idle state
         @(vif.master_cb);
//  before entering the setup state checking the reset is happern or not
         if(!vif.presetn||$isunknown(vif.presetn))begin
// if reset is occurs this transaction should be save and send the transaction to sequence again comes next transaction same data with flag =1 sending extra for identify the reset data.            
            $cast(transaction_res_h,transaction_req_h.clone());
            transaction_res_h.set_id_info(transaction_req_h);
            transaction_res_h.flag=1;
            `uvm_info("reset","reset occuring before entering setup",   UVM_LOW );
            `uvm_info("reset data",$sformatf(" before setup reset is detected reset data =%0s",transaction_res_h.sprint()) ,UVM_LOW);
            `uvm_info("driver to sequence","response data passed to sequence before entering the setup",   UVM_LOW );
            reset_logic(transaction_req_h);
         end
         else begin
// the trasaction data is sended to dut using the virtual interface
         vif.master_cb.psel<=1'b1;
         vif.master_cb.penable<=1'b0;
         vif.master_cb.paddr<=transaction_req_h.paddr;
         vif.master_cb.pwdata<=transaction_req_h.pwdata;
         vif.master_cb.pwrite<=transaction_req_h.pwrite;
         end
//  before entering the setup state reset is checking     
         @(vif.master_cb);
         if(!vif.presetn||$isunknown(vif.presetn))begin
            $cast(transaction_res_h,transaction_req_h.clone());
            transaction_res_h.set_id_info(transaction_req_h);
            `uvm_info("reset","reset occuring before entering access",   UVM_LOW );
            `uvm_info("reset data",$sformatf(" before access reset is detected reset data =%0s",transaction_res_h.sprint()) ,UVM_LOW);
            transaction_res_h.flag=1;
            `uvm_info("driver to sequence","response data passed to sequence before entering the acdcess ",   UVM_LOW );
            reset_logic(transaction_req_h);
            return;
         end
         else begin
// entering the access state penable is 1
         vif.master_cb.penable<=1'b1;
         end

//  before receving the pready checking the presetn
         @(vif.master_cb);
      while(!vif.master_cb.pready)begin
         if(!vif.presetn||$isunknown(vif.presetn))begin
            $cast(transaction_res_h,transaction_req_h.clone());
            transaction_res_h.set_id_info(transaction_req_h);
            transaction_res_h.flag=1;
            `uvm_info("reset","reset occuring before receving the pready ",UVM_LOW );
            `uvm_info("rd",$sformatf("reset data =%0s",transaction_res_h.sprint()) ,UVM_LOW);
            `uvm_info("driver to sequence","response data passed to sequence  before receving the pready",UVM_LOW );
            reset_logic(transaction_req_h);
            return;
         end
         else begin
         wait_count++;
//  here checking the pready receving within 5 clk cyles or not 
         if(wait_count>=5&&!vif.pready)
            `uvm_fatal(get_type_name(),$sformatf("wait count reached maximum %0d",wait_count));
         @(vif.master_cb);
         end
      end
      `uvm_info("pready",$sformatf("pready occured at =%0d clock pulse %0d",wait_count,vif.pready),UVM_LOW);
      wait_count=0;

         @(vif.master_cb);
//  transaction is completed psel and penable become 1'b0         
         `uvm_info("rd",$sformatf("transaction completed data =%0s",transaction_req_h.sprint()) ,UVM_LOW);
         vif.master_cb.psel<=1'b0;
         vif.master_cb.penable<=1'b0;
      
   endtask:driver_logic

endclass:apb_driver
`endif
