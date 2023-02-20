package dut_uvm_package;
    class DUTParams;
        parameter VAR_WIDTH = 16;
        parameter MUL_FACTOR = 2;
        parameter DUT_NUMBER = 2;
    endclass

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "s_dut_sequence_item.svh"
    `include "s_dut_sequence.svh"
    `include "s_dut_driver.svh"
    `include "s_dut_monitor.svh"
    `include "s_dut_coverage.svh"
    `include "s_dut_agent.svh"

    `include "m_dut_sequence_item.svh"
    `include "m_dut_sequence.svh"
    `include "m_dut_driver.svh"
    `include "m_dut_monitor.svh"
    `include "m_dut_agent.svh"
    
    `include "dut_rst_sequence_item.svh"
    `include "dut_rst_sequence.svh"
    `include "dut_rst_driver.svh"
    `include "dut_rst_agent.svh"
    `include "dut_virtual_sequence.svh"
    `include "dut_scoreboard.svh"
    `include "dut_env.svh"
    `include "dut_test.svh"
    `include "dut_test_wrapper.svh"
endpackage