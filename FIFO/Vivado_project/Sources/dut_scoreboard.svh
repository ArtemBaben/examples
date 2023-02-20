class dut_scoreboard #(int VAR_WIDTH = 16, int MUL_FACTOR = 2, int DUT_NUMBER = 1) extends uvm_scoreboard;
    `uvm_component_param_utils(dut_scoreboard #(VAR_WIDTH, MUL_FACTOR, DUT_NUMBER))

    uvm_blocking_get_port #(s_dut_sequence_item #(VAR_WIDTH))             tlm_fifo_get_port_i[DUT_NUMBER];
    uvm_blocking_get_port #(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR)) tlm_fifo_get_port_o[DUT_NUMBER];

    int unsigned iteration;

    extern function new(string name = "dut_scoreboard", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass


function dut_scoreboard::new (string name = "dut_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    $display ("dut_scoreboard::new done with params: VAR_WIDTH = %02d, MUL_FACTOR = %02d, DUT_NUMBER = %02d", VAR_WIDTH, MUL_FACTOR, DUT_NUMBER);
endfunction


function void dut_scoreboard::build_phase(uvm_phase phase);
    for (int i = 0; i < DUT_NUMBER; i++) begin
        tlm_fifo_get_port_i[i] = new ($sformatf("tlm_fifo_get_port_i_%02d", i), this);
        tlm_fifo_get_port_o[i] = new ($sformatf("tlm_fifo_get_port_o_%02d", i), this);
    end
endfunction


task dut_scoreboard::main_phase(uvm_phase phase);
    s_dut_sequence_item #(VAR_WIDTH) dut_sequence_item_i[DUT_NUMBER];
    m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR) dut_sequence_item_o[DUT_NUMBER];
    bit [(VAR_WIDTH + (MUL_FACTOR-1))-1:0] predicted_val[DUT_NUMBER];
    string data_str[DUT_NUMBER];    

    forever begin
        for (int i = 0; i < DUT_NUMBER; i++) begin
            tlm_fifo_get_port_i[i].get(dut_sequence_item_i[i]);
            tlm_fifo_get_port_o[i].get(dut_sequence_item_o[i]);

            if ((dut_sequence_item_i[i] != null) || (dut_sequence_item_o[i] != null)) begin
                $display("\nAgent %02d status:", i);
                predicted_val[i] = dut_sequence_item_i[i].s_axis_tdata * MUL_FACTOR;
                data_str[i] = {
                    "\n", "iteration: ", $sformatf("%d", this.iteration),
                    "\n", "input value: ", dut_sequence_item_i[i].convert2string(),
                    "\n", "output value: ", dut_sequence_item_o[i].convert2string(),
                    "\n", "predicted: ", $sformatf("%d", predicted_val[i])
                };
                if (dut_sequence_item_o[i].m_axis_tdata != predicted_val[i]) 
                    `uvm_error("FAIL", data_str[i])
                else `uvm_info("PASS", data_str[i], UVM_NONE)
            end
        end
        this.iteration++;
    end
endtask