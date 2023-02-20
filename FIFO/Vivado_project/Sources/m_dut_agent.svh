class m_dut_agent #(int VAR_WIDTH = 16, int MUL_FACTOR = 2) extends uvm_agent;
    `uvm_component_param_utils(m_dut_agent #(VAR_WIDTH, MUL_FACTOR))

    virtual m_axis_if #(VAR_WIDTH, MUL_FACTOR)                        m_dut_if;
    uvm_sequencer     #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)) m_dut_sequencer_inst;
    m_dut_driver      #(VAR_WIDTH, MUL_FACTOR)                        m_dut_driver_inst;
    m_dut_monitor     #(VAR_WIDTH, MUL_FACTOR)                        m_dut_monitor_inst;

    extern function new(string name = "m_dut_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass


function m_dut_agent::new(string name = "m_dut_agent", uvm_component parent);
    super.new(name, parent);
    $display ("m_dut_agent::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d", VAR_WIDTH, MUL_FACTOR);
endfunction


function void m_dut_agent::build_phase(uvm_phase phase);
    m_dut_sequencer_inst = uvm_sequencer #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR))::type_id::create("m_dut_sequencer_inst", this);
    m_dut_driver_inst = m_dut_driver #(VAR_WIDTH, MUL_FACTOR)::type_id::create("m_dut_driver_inst", this);
    m_dut_driver_inst.m_dut_if = this.m_dut_if;
    m_dut_monitor_inst = m_dut_monitor #(VAR_WIDTH, MUL_FACTOR)::type_id::create("m_dut_monitor_inst", this);
    m_dut_monitor_inst.m_dut_if = this.m_dut_if;
endfunction


function void m_dut_agent::connect_phase(uvm_phase phase);
    m_dut_driver_inst.seq_item_port.connect(m_dut_sequencer_inst.seq_item_export);
endfunction