`timescale 1ns / 1ps

module TB_top();
    parameter S_AXIS_CLK_FREQ = 200;
    parameter M_AXIS_CLK_FREQ = 50;

    import uvm_pkg::*;
    import dut_uvm_package::*;

    bit s_axis_clk = 0;
    bit m_axis_clk = 0;
    bit rst_n;

    always #($itor(1000)/$itor(S_AXIS_CLK_FREQ)/2) s_axis_clk = ~s_axis_clk;
    always #($itor(1000)/$itor(M_AXIS_CLK_FREQ)/2) m_axis_clk = ~m_axis_clk;

    s_axis_if #(.VAR_WIDTH(DUTParams::VAR_WIDTH)) s_dut_if [DUTParams::DUT_NUMBER] (.clk(s_axis_clk), .rst_n(rst_n));
    m_axis_if #(.VAR_WIDTH(DUTParams::VAR_WIDTH), .MUL_FACTOR(DUTParams::MUL_FACTOR)) m_dut_if [DUTParams::DUT_NUMBER] (.clk(m_axis_clk));

    wire [$size(m_dut_if[0].m_axis_tdata)-1:0] axis_mul_tdata [DUTParams::DUT_NUMBER];
    wire axis_mul_tvalid [DUTParams::DUT_NUMBER];
    wire axis_mul_tready [DUTParams::DUT_NUMBER];

    generate
        for (genvar i = 0; i < DUTParams::DUT_NUMBER; i++) begin
            initial begin
                uvm_config_db #(virtual s_axis_if #(.VAR_WIDTH(DUTParams::VAR_WIDTH)))::
                                        set(null, "*", $sformatf("s_dut_if_%02d", i), s_dut_if[i]);
                                        
                uvm_config_db #(virtual m_axis_if #(.VAR_WIDTH(DUTParams::VAR_WIDTH), .MUL_FACTOR(DUTParams::MUL_FACTOR)))::
                                        set(null, "*", $sformatf("m_dut_if_%02d", i), m_dut_if[i]);
            end
            
            axis_mul #(.MUL_FACTOR(DUTParams::MUL_FACTOR),
                       .VAR_WIDTH (DUTParams::VAR_WIDTH))
            dut_axis_mul(
                .s_axis_tdata  (s_dut_if[i].s_axis_tdata ),
                .s_axis_tvalid (s_dut_if[i].s_axis_tvalid),
                .s_axis_tready (s_dut_if[i].s_axis_tready),

                .m_axis_tdata  (axis_mul_tdata [i]),
                .m_axis_tvalid (axis_mul_tvalid[i]),
                .m_axis_tready (axis_mul_tready[i]),

                .clk           (s_dut_if[i].clk),
                .rst_n         (s_dut_if[i].rst_n)
            );

            axis_data_fifo_0 dut_axis_data_fifo (
                .s_axis_aresetn (s_dut_if[i].rst_n),
                .s_axis_aclk    (s_dut_if[i].clk),
                .s_axis_tvalid  (axis_mul_tvalid[i]),
                .s_axis_tready  (axis_mul_tready[i]),
                .s_axis_tdata   (axis_mul_tdata [i]),
                .m_axis_aclk    (m_dut_if[i].clk),
                .m_axis_tvalid  (m_dut_if[i].m_axis_tvalid),
                .m_axis_tready  (m_dut_if[i].m_axis_tready),
                .m_axis_tdata   (m_dut_if[i].m_axis_tdata )
            );
        end
    endgenerate


    initial begin
        run_test("dut_test_wrapper");
    end
endmodule