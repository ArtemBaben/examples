class dut_rst_sequence extends uvm_sequence #(dut_rst_sequence_item);
    `uvm_object_utils(dut_rst_sequence)

    dut_rst_sequence_item dut_rst_sequence_item_inst;
    
    extern function new(string name = "dut_rst_sequence");
    extern task body();
endclass


function dut_rst_sequence::new(string name = "dut_rst_sequence");
    super.new(name);
    $display ("dut_rst_sequence::new done");
endfunction


task dut_rst_sequence::body();
    dut_rst_sequence_item_inst = dut_rst_sequence_item::type_id::create("dut_rst_sequence_item_inst");
    start_item(dut_rst_sequence_item_inst);
        assert(dut_rst_sequence_item_inst.randomize());
    finish_item(dut_rst_sequence_item_inst);
endtask