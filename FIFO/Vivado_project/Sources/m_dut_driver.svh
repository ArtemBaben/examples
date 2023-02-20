class m_dut_driver #(int VAR_WIDTH = 16, int MUL_FACTOR = 2) extends uvm_driver #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR));
    `uvm_component_param_utils(m_dut_driver #(VAR_WIDTH, MUL_FACTOR))

    virtual m_axis_if   #(VAR_WIDTH, MUL_FACTOR) m_dut_if;
    m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR) m_dut_sequence_item_inst;

    extern function new(string name = "m_dut_driver", uvm_component parent);
    extern task main_phase(uvm_phase phase);
endclass


function m_dut_driver::new(string name = "m_dut_driver", uvm_component parent);
    super.new(name, parent);
    $display ("m_dut_driver::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d", VAR_WIDTH, MUL_FACTOR);
endfunction


task m_dut_driver::main_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(m_dut_sequence_item_inst);
            foreach (m_dut_sequence_item_inst.m_axis_tready[i]) begin
                @(posedge m_dut_if.clk) begin
                    m_dut_if.m_axis_tready <= m_dut_sequence_item_inst.m_axis_tready[i];
                end
            end
        seq_item_port.item_done();
    end
endtask
