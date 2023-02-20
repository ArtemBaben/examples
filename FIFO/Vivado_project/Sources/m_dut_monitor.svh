class m_dut_monitor #(int VAR_WIDTH = 16, int MUL_FACTOR = 2) extends uvm_monitor;
    `uvm_component_param_utils(m_dut_monitor #(VAR_WIDTH, MUL_FACTOR))

    m_dut_sequence_item   #(VAR_WIDTH, MUL_FACTOR)                        m_dut_sequence_item_o;
    uvm_blocking_put_port #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)) m_tlm_fifo_put_port;
    virtual m_axis_if     #(VAR_WIDTH, MUL_FACTOR)                        m_dut_if;

    extern function new(string name = "m_dut_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass


function m_dut_monitor::new(string name = "m_dut_monitor", uvm_component parent = null);
    super.new(name, parent);
    $display ("m_dut_monitor::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d", VAR_WIDTH, MUL_FACTOR);
endfunction

function void m_dut_monitor::build_phase(uvm_phase phase);
    m_tlm_fifo_put_port = new ("m_tlm_fifo_put_port", this);
endfunction


task m_dut_monitor::main_phase(uvm_phase phase);
    forever begin
        @(posedge m_dut_if.clk) begin
            m_dut_sequence_item_o = m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)::type_id::create("m_axim_dut_sequence_item_o");
            if (m_dut_if.m_axis_tvalid && m_dut_if.m_axis_tready) begin
                m_dut_sequence_item_o.m_axis_tdata = m_dut_if.m_axis_tdata;
                m_tlm_fifo_put_port.put(m_dut_sequence_item_o);
            end
        end
    end
endtask