`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2022 12:10:29 PM
// Design Name: 
// Module Name: axis_mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_mul #(parameter MUL_FACTOR = 2,
                  parameter VAR_WIDTH = 16)(
        input  wire  [VAR_WIDTH-1:0] s_axis_tdata,
        input  wire  s_axis_tvalid,
        output logic s_axis_tready,

        output logic [(VAR_WIDTH + (MUL_FACTOR-1))-1:0] m_axis_tdata,
        output logic m_axis_tvalid,
        input  wire  m_axis_tready,

        input wire clk,
        input wire rst_n
    );


    always_ff @(posedge clk) begin
        if (!rst_n) begin
            s_axis_tready <= 0;
            m_axis_tdata  <= 0;
            m_axis_tvalid <= 0;
        end
        else begin
            s_axis_tready <= m_axis_tready;
            m_axis_tvalid <= s_axis_tready & s_axis_tvalid;
            m_axis_tdata  <= (s_axis_tdata << (MUL_FACTOR-1));
        end
    end

    // always_comb begin
    //     if (!rst_n) begin
    //         s_axis_tready = 0;
    //         m_axis_tdata  = 0;
    //         m_axis_tvalid = 0;
    //     end
    //     else begin
    //         s_axis_tready = m_axis_tready;
    //         m_axis_tvalid = s_axis_tvalid;
    //         m_axis_tdata  = (s_axis_tdata << (MUL_FACTOR-1));
    //     end
    // end

endmodule
