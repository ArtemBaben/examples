class s_dut_driver #(int VAR_WIDTH = 16) extends uvm_driver #(s_dut_sequence_item #(VAR_WIDTH));
    `uvm_component_param_utils(s_dut_driver #(VAR_WIDTH))

    virtual s_axis_if   #(VAR_WIDTH) s_dut_if;
    s_dut_sequence_item #(VAR_WIDTH) s_dut_sequence_item_inst;
    int count;

    extern function new(string name = "s_dut_driver", uvm_component parent);
    extern task reset_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass


function s_dut_driver::new(string name = "s_dut_driver", uvm_component parent);
    super.new(name, parent);
    $display ("s_dut_driver::new done with params: VAR_WIDTH = %02d", VAR_WIDTH);
endfunction


task s_dut_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Applying initial reset"), UVM_MEDIUM);
    s_dut_if.rst_n = 0;
    repeat (20) begin
        @(posedge s_dut_if.clk);
        `uvm_info(get_type_name(), $sformatf("%02d. DUT reset in progress", count), UVM_LOW);
        count++;
    end
    s_dut_if.rst_n = 1;
    `uvm_info(get_type_name(), $sformatf("DUT reset was done"), UVM_MEDIUM);
endtask


task s_dut_driver::main_phase(uvm_phase phase);
    s_dut_if.s_axis_tdata = 0;
    s_dut_if.s_axis_tvalid = 0;
    wait (s_dut_if.rst_n == 1);
    forever begin
        seq_item_port.get_next_item(s_dut_sequence_item_inst);
            foreach (s_dut_sequence_item_inst.s_axis_tvalid[i]) begin
                @(posedge s_dut_if.clk)
                    s_dut_if.s_axis_tvalid <= s_dut_sequence_item_inst.s_axis_tvalid[i];
                    if (s_dut_if.s_axis_tready && s_dut_if.s_axis_tvalid)
                        s_dut_if.s_axis_tdata <= s_dut_sequence_item_inst.s_axis_tdata;
            end
        seq_item_port.item_done();
    end
endtask
