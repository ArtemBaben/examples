class m_dut_sequence #(int VAR_WIDTH = 16, int MUL_FACTOR = 2) extends uvm_sequence #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR));
    `uvm_object_param_utils(m_dut_sequence #(VAR_WIDTH, MUL_FACTOR))

    m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR) m_dut_sequence_item_inst;
    
    int unsigned run_iterations;
    int unsigned items_done;

    extern function new(string name = "m_dut_sequence");
    extern task body();
endclass


function m_dut_sequence::new(string name = "m_dut_sequence");
    super.new(name);
    $display ("m_dut_sequence::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d", VAR_WIDTH, MUL_FACTOR);
endfunction


task m_dut_sequence::body();
    m_dut_sequence_item_inst = m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)::type_id::create("m_dut_sequence_item_inst");
    repeat(run_iterations) begin
        start_item(m_dut_sequence_item_inst);
            assert(m_dut_sequence_item_inst.randomize())
        finish_item(m_dut_sequence_item_inst);
        items_done++;
    end
endtask