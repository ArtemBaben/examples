`timescale 1ns / 1ps

interface s_axis_if #(int VAR_WIDTH = 16)(input bit clk,
                                          input bit rst_n);
    logic [VAR_WIDTH-1:0] s_axis_tdata;
    logic s_axis_tvalid;
    logic s_axis_tready;
endinterface


interface m_axis_if #(int VAR_WIDTH = 16,
                      int MUL_FACTOR = 2)(input bit clk);

    logic [(VAR_WIDTH + (MUL_FACTOR-1))-1:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready;
endinterface