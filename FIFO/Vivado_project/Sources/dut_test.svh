class dut_test #(int VAR_WIDTH = 16, int MUL_FACTOR = 2, int DUT_NUMBER = 1) extends uvm_test;
    `uvm_component_param_utils(dut_test #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER))

    dut_env #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER)              dut_env_inst;
    dut_virtual_sequence #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER) dut_virtual_sequence_inst;

    extern function new(string name = "", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass


function dut_test::new(string name = "", uvm_component parent);
    super.new(name, parent);
    $display ("dut_test::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d, DUT_NUMBER = %02d", 
                VAR_WIDTH, MUL_FACTOR, DUT_NUMBER);
endfunction


function void dut_test::build_phase(uvm_phase phase);
    dut_env_inst = dut_env #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER)::type_id::create("dut_env_inst", this);
    dut_virtual_sequence_inst = dut_virtual_sequence #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER)::type_id::create("dut_virtual_sequence_inst", this);
    dut_virtual_sequence_inst.run_iterations = 500;
endfunction


function void dut_test::connect_phase(uvm_phase phase);
    for (int i = 0; i < DUT_NUMBER; i++) begin
        dut_virtual_sequence_inst.s_dut_sequencer_inst[i] = dut_env_inst.s_dut_agent_inst[i].s_dut_sequencer_inst;
        dut_virtual_sequence_inst.m_dut_sequencer_inst[i] = dut_env_inst.m_dut_agent_inst[i].m_dut_sequencer_inst;
        dut_virtual_sequence_inst.dut_rst_sequencer_inst[i] = dut_env_inst.dut_rst_agent_inst[i].dut_rst_sequencer_inst;
    end
endfunction


function void dut_test::end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
endfunction


task dut_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
        dut_virtual_sequence_inst.start(null);
    phase.drop_objection(this);
endtask