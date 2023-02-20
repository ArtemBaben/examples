class dut_rst_driver #(int VAR_WIDTH = 16) extends uvm_driver #(dut_rst_sequence_item);
    `uvm_component_param_utils(dut_rst_driver #(VAR_WIDTH))

    virtual s_axis_if #(VAR_WIDTH) s_dut_if;
    dut_rst_sequence_item dut_rst_sequence_item_inst;
    int count;

    extern function new(string name = "dut_rst_driver", uvm_component parent);
    extern task main_phase(uvm_phase phase);
endclass


function dut_rst_driver::new(string name = "dut_rst_driver", uvm_component parent);
    super.new(name, parent);
    $display ("dut_rst_driver::new done with params: VAR_WIDTH = %02d", VAR_WIDTH);
endfunction


task dut_rst_driver::main_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(dut_rst_sequence_item_inst);
            foreach (dut_rst_sequence_item_inst.rst_sequence[i]) begin
                @(posedge s_dut_if.clk)
                    s_dut_if.rst_n <= dut_rst_sequence_item_inst.rst_sequence[i];
            end
        seq_item_port.item_done();
    end
endtask
