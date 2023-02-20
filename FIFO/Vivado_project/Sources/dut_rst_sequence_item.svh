class dut_rst_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(dut_rst_sequence_item)

    bit rst_sequence[] = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0,
                          1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1};

    extern function new (string name = "dut_rst_sequence_item"); 
endclass


function dut_rst_sequence_item::new (string name = "dut_rst_sequence_item"); 
    super.new(name);
    $display("dut_rst_sequence_item new done");
    foreach (rst_sequence[i])
        $display("rst_sequence[%02d] = %02d", i, rst_sequence[i]);
endfunction
