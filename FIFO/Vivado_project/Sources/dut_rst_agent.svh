class dut_rst_agent #(int VAR_WIDTH = 16) extends uvm_agent;
    `uvm_component_param_utils(dut_rst_agent #(VAR_WIDTH))

    virtual s_axis_if #(VAR_WIDTH)             s_dut_if;
    uvm_sequencer     #(dut_rst_sequence_item) dut_rst_sequencer_inst;
    dut_rst_driver    #(VAR_WIDTH)             dut_rst_driver_inst;

    extern function new(string name = "dut_rst_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass


function dut_rst_agent::new(string name = "dut_rst_agent", uvm_component parent);
    super.new(name, parent);
    $display ("dut_rst_agent::new done with params: VAR_WIDTH = %02d", VAR_WIDTH);
endfunction


function void dut_rst_agent::build_phase(uvm_phase phase);
    dut_rst_sequencer_inst = uvm_sequencer #(dut_rst_sequence_item)::type_id::create("dut_rst_sequencer_inst", this);
    dut_rst_driver_inst = dut_rst_driver #(VAR_WIDTH)::type_id::create("dut_rst_driver_inst", this);
    dut_rst_driver_inst.s_dut_if = this.s_dut_if;
endfunction


function void dut_rst_agent::connect_phase(uvm_phase phase);
    dut_rst_driver_inst.seq_item_port.connect(dut_rst_sequencer_inst.seq_item_export);
endfunction