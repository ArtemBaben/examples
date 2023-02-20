class s_dut_sequence #(int VAR_WIDTH = 16) extends uvm_sequence #(s_dut_sequence_item #(VAR_WIDTH));
    `uvm_object_param_utils(s_dut_sequence #(VAR_WIDTH))

    s_dut_sequence_item #(VAR_WIDTH) s_dut_sequence_item_inst;
    
    int unsigned run_iterations;
    int unsigned items_done;

    extern function new(string name = "s_dut_sequence");
    extern task body();
endclass


function s_dut_sequence::new(string name = "s_dut_sequence");
    super.new(name);
    $display ("s_dut_sequence::new done with params: VAR_WIDTH = %02d", VAR_WIDTH);
endfunction


task s_dut_sequence::body();
    s_dut_sequence_item_inst = s_dut_sequence_item #(VAR_WIDTH)::type_id::create("s_dut_sequence_item_inst");
    repeat(run_iterations) begin
        start_item(s_dut_sequence_item_inst);
            assert(s_dut_sequence_item_inst.randomize())
        finish_item(s_dut_sequence_item_inst);
        items_done++;
    end
endtask