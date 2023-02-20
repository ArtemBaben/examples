class dut_env #(int VAR_WIDTH = 16, int MUL_FACTOR = 2, int DUT_NUMBER = 1) extends uvm_env;
    `uvm_component_param_utils(dut_env #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER))

    virtual s_axis_if #(VAR_WIDTH)             s_dut_if [DUT_NUMBER];
    virtual m_axis_if #(VAR_WIDTH, MUL_FACTOR) m_dut_if [DUT_NUMBER];

    s_dut_agent #(VAR_WIDTH, MUL_FACTOR) s_dut_agent_inst [DUT_NUMBER];
    m_dut_agent #(VAR_WIDTH, MUL_FACTOR) m_dut_agent_inst [DUT_NUMBER];

    dut_rst_agent #(VAR_WIDTH) dut_rst_agent_inst [DUT_NUMBER];

    uvm_tlm_analysis_fifo #(s_dut_sequence_item #(VAR_WIDTH))             s_tlm_fifo [DUT_NUMBER];
    uvm_tlm_analysis_fifo #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)) m_tlm_fifo [DUT_NUMBER];

    dut_scoreboard #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER) dut_scoreboard_inst;
    s_dut_coverage #(VAR_WIDTH) s_dut_coverage_inst [DUT_NUMBER];

    extern function new(string name = "dut_env", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass


function dut_env::new(string name = "dut_env", uvm_component parent);
    super.new(name, parent);
    $display ("dut_env::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d, DUT_NUMBER = %02d", VAR_WIDTH, MUL_FACTOR, DUT_NUMBER);
endfunction


function void dut_env::build_phase(uvm_phase phase);
    dut_scoreboard_inst = dut_scoreboard #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER)::type_id::create("dut_scoreboard_inst", this);
    
    for (int i = 0; i < DUT_NUMBER; i++) begin
        if (!uvm_config_db #(virtual s_axis_if #(VAR_WIDTH))::get(this, "", $sformatf("s_dut_if_%02d", i), s_dut_if[i]))
            `uvm_fatal("BFM", "Failed to get s_axis BFM");
        if (!uvm_config_db #(virtual m_axis_if #(VAR_WIDTH, MUL_FACTOR))::get(this, "", $sformatf("m_dut_if_%02d", i), m_dut_if[i]))
            `uvm_fatal("BFM", "Failed to get m_axis BFM");
    
        s_dut_agent_inst[i] = s_dut_agent #(VAR_WIDTH, MUL_FACTOR)::type_id::create($sformatf("s_dut_agent_inst_%02d", i), this);
        s_dut_agent_inst[i].s_dut_if = this.s_dut_if[i];
        m_dut_agent_inst[i] = m_dut_agent #(VAR_WIDTH, MUL_FACTOR)::type_id::create($sformatf("m_dut_agent_inst_%02d", i), this);
        m_dut_agent_inst[i].m_dut_if = this.m_dut_if[i];
        s_dut_coverage_inst[i] = s_dut_coverage #(VAR_WIDTH)::type_id::create($sformatf("s_dut_coverage_inst_%02d", i), this);
        s_tlm_fifo[i] = new ($sformatf("s_tlm_fifo_%02d", i), this);
        m_tlm_fifo[i] = new ($sformatf("m_tlm_fifo_%02d", i), this);
        dut_rst_agent_inst[i] = dut_rst_agent #(VAR_WIDTH)::type_id::create($sformatf("dut_rst_agent_inst_%02d", i), this);
        dut_rst_agent_inst[i].s_dut_if = this.s_dut_if[i];
    end
endfunction


function void dut_env::connect_phase(uvm_phase phase);
    for (int i = 0; i < DUT_NUMBER; i++) begin
        s_dut_agent_inst[i].s_dut_monitor_inst.s_tlm_fifo_put_port.connect(s_tlm_fifo[i].put_export);
        m_dut_agent_inst[i].m_dut_monitor_inst.m_tlm_fifo_put_port.connect(m_tlm_fifo[i].put_export);
        dut_scoreboard_inst.tlm_fifo_get_port_i[i].connect(s_tlm_fifo[i].get_export);
        dut_scoreboard_inst.tlm_fifo_get_port_o[i].connect(m_tlm_fifo[i].get_export);
        s_dut_agent_inst[i].s_dut_monitor_inst.analysis_port.connect(s_dut_coverage_inst[i].analysis_export);
    end
endfunction