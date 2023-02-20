class s_dut_coverage #(int VAR_WIDTH = 16) extends uvm_subscriber #(s_dut_sequence_item #(VAR_WIDTH));
    `uvm_component_param_utils(s_dut_coverage #(VAR_WIDTH))

    s_dut_sequence_item #(VAR_WIDTH) transaction;
    int transaction_cnt;
    real current_coverage;

    covergroup cov;
        coverpoint transaction.s_axis_tdata;
    endgroup

    extern function new(string name = "s_dut_coverage", uvm_component parent);
    extern function void write(s_dut_sequence_item #(VAR_WIDTH) t);
endclass


function s_dut_coverage::new(string name = "s_dut_coverage", uvm_component parent);
    super.new(name, parent);
    cov = new();
    $display ("s_dut_coverage::new done with params: VAR_WIDTH = %02d", VAR_WIDTH);
endfunction


function void s_dut_coverage::write(s_dut_sequence_item #(VAR_WIDTH) t);
    transaction = t;
    transaction_cnt++;
    cov.sample();
    current_coverage = $get_coverage();
    `uvm_info("Coverage", $sformatf("%0d Packets sampled, Coverage = %f%%", transaction_cnt, current_coverage), UVM_MEDIUM);
endfunction