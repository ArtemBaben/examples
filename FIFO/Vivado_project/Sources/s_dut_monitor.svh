class s_dut_monitor #(int VAR_WIDTH = 16) extends uvm_monitor;
    `uvm_component_param_utils(s_dut_monitor #(VAR_WIDTH))

    s_dut_sequence_item   #(VAR_WIDTH)                        s_dut_sequence_item_i;
    uvm_blocking_put_port #(s_dut_sequence_item #(VAR_WIDTH)) s_tlm_fifo_put_port;
    uvm_analysis_port     #(s_dut_sequence_item #(VAR_WIDTH)) analysis_port;
    virtual s_axis_if     #(VAR_WIDTH)                        s_dut_if;

    extern function new(string name = "s_dut_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass


function s_dut_monitor::new(string name = "s_dut_monitor", uvm_component parent = null);
    super.new(name, parent);
    $display ("s_dut_monitor::new done with params: VAR_WIDTH = %02d", VAR_WIDTH);
endfunction


function void s_dut_monitor::build_phase(uvm_phase phase);
    s_tlm_fifo_put_port = new("s_tlm_fifo_put_port", this);
    analysis_port = new("analysis_port", this);
endfunction


task s_dut_monitor::main_phase(uvm_phase phase);
    forever begin
        s_dut_sequence_item_i = s_dut_sequence_item #(VAR_WIDTH)::type_id::create("s_axis_dut_sequence_item_i");
        @(posedge s_dut_if.clk) begin
            if (s_dut_if.s_axis_tvalid && s_dut_if.s_axis_tready) begin
                s_dut_sequence_item_i.s_axis_tdata = s_dut_if.s_axis_tdata;
                s_tlm_fifo_put_port.put(s_dut_sequence_item_i);
                analysis_port.write(s_dut_sequence_item_i);
            end
        end
    end
endtask