class s_dut_agent #(int VAR_WIDTH = 16, int MUL_FACTOR = 2) extends uvm_agent;
    `uvm_component_param_utils(s_dut_agent #(VAR_WIDTH, MUL_FACTOR))

    virtual s_axis_if #(VAR_WIDTH)                        s_dut_if;
    uvm_sequencer     #(s_dut_sequence_item #(VAR_WIDTH)) s_dut_sequencer_inst;
    s_dut_driver      #(VAR_WIDTH)                        s_dut_driver_inst;
    s_dut_monitor     #(VAR_WIDTH)                        s_dut_monitor_inst;

    extern function new(string name = "s_dut_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass


function s_dut_agent::new(string name = "s_dut_agent", uvm_component parent);
    super.new(name, parent);
    $display ("s_dut_agent::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d", VAR_WIDTH, MUL_FACTOR);
endfunction


function void s_dut_agent::build_phase(uvm_phase phase);
    s_dut_sequencer_inst = uvm_sequencer #(s_dut_sequence_item #(VAR_WIDTH))::type_id::create("s_dut_sequencer_inst", this);
    s_dut_driver_inst = s_dut_driver #(VAR_WIDTH)::type_id::create("s_dut_driver_inst", this);
    s_dut_driver_inst.s_dut_if = this.s_dut_if;
    s_dut_monitor_inst = s_dut_monitor #(VAR_WIDTH)::type_id::create("s_dut_monitor_inst", this);
    s_dut_monitor_inst.s_dut_if = this.s_dut_if;
endfunction


function void s_dut_agent::connect_phase(uvm_phase phase);
    s_dut_driver_inst.seq_item_port.connect(s_dut_sequencer_inst.seq_item_export);
endfunction