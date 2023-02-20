class dut_test_wrapper extends dut_test #(DUTParams::VAR_WIDTH, DUTParams::MUL_FACTOR, DUTParams::DUT_NUMBER);
    `uvm_component_utils(dut_test_wrapper)

    extern function new(string name = "dut_test_wrapper", uvm_component parent);
    extern function void build_phase(uvm_phase phase); 
endclass


function dut_test_wrapper::new(string name = "dut_test_wrapper", uvm_component parent);
    super.new(name, parent);
    $display ("dut_test_wrapper::new done");
endfunction


function void dut_test_wrapper::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


