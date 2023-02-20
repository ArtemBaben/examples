class dut_virtual_sequence #(int VAR_WIDTH = 16, int MUL_FACTOR = 2, int DUT_NUMBER = 1) extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_param_utils(dut_virtual_sequence #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER));

    s_dut_sequence #(VAR_WIDTH)             s_dut_sequence_inst [DUT_NUMBER];
    m_dut_sequence #(VAR_WIDTH, MUL_FACTOR) m_dut_sequence_inst [DUT_NUMBER];
    dut_rst_sequence                        dut_rst_sequence_inst [DUT_NUMBER];

    uvm_sequencer #(s_dut_sequence_item #(VAR_WIDTH))             s_dut_sequencer_inst [DUT_NUMBER];
    uvm_sequencer #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)) m_dut_sequencer_inst [DUT_NUMBER];
    uvm_sequencer #(dut_rst_sequence_item) dut_rst_sequencer_inst [DUT_NUMBER];

    int unsigned run_iterations;

    extern function new(string name = "dut_virtual_sequence");
    extern task body();
endclass


function dut_virtual_sequence::new(string name = "dut_virtual_sequence");
    super.new(name);
    $display ("dut_virtual_sequence::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d, DUT_NUMBER = %02d", VAR_WIDTH, MUL_FACTOR, DUT_NUMBER);
endfunction


task dut_virtual_sequence::body();
    for (int i = 0; i < DUT_NUMBER; i++) begin
        s_dut_sequence_inst[i] = s_dut_sequence #(VAR_WIDTH)::type_id::create($sformatf("s_dut_sequence_inst_%02d", i));
        m_dut_sequence_inst[i] = m_dut_sequence #(VAR_WIDTH, MUL_FACTOR)::type_id::create($sformatf("m_dut_sequence_inst_%02d", i));
        dut_rst_sequence_inst[i] = dut_rst_sequence::type_id::create($sformatf("dut_rst_sequence_inst_%02d", i));
        s_dut_sequence_inst[i].run_iterations = this.run_iterations;
        m_dut_sequence_inst[i].run_iterations = this.run_iterations;
    end

    fork
        dut_rst_sequence_inst[0].start(dut_rst_sequencer_inst[0]);
        dut_rst_sequence_inst[1].start(dut_rst_sequencer_inst[1]);
    join

    fork
        s_dut_sequence_inst[0].start(s_dut_sequencer_inst[0]);
        m_dut_sequence_inst[0].start(m_dut_sequencer_inst[0]);
        s_dut_sequence_inst[1].start(s_dut_sequencer_inst[1]);
        m_dut_sequence_inst[1].start(m_dut_sequencer_inst[1]);
    join

    for (int i = 0; i < DUT_NUMBER; i++) begin
        $display("s_dut_sequence_inst[%02d] iterations done: %02d", i, s_dut_sequence_inst[i].items_done);
        $display("m_dut_sequence_inst[%02d] iterations done: %02d", i, m_dut_sequence_inst[i].items_done);
    end
endtask