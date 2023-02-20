class m_dut_sequence_item #(int VAR_WIDTH = 16, int MUL_FACTOR = 2) extends uvm_sequence_item;
    `uvm_object_param_utils(m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR))

    rand bit m_axis_tready[];
    bit [(VAR_WIDTH + (MUL_FACTOR-1))-1:0] m_axis_tdata;

    constraint c_m_axis_tready{
        foreach (m_axis_tready[i])
            m_axis_tready[i] inside {[0:1]};
        m_axis_tready.size inside {[2:3]};
        m_axis_tready.sum == 1;
    }

    extern function new(string name = "m_dut_sequence_item"); 
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string(); 
endclass


function m_dut_sequence_item::new(string name = "m_dut_sequence_item"); 
    super.new(name);
endfunction


function bit m_dut_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    m_dut_sequence_item #(VAR_WIDTH, MUL_FACTOR) rhs_inst;
    bit same;
    same = super.do_compare(rhs, comparer);
    $cast(rhs_inst, rhs);
    same = (m_axis_tdata == rhs_inst.m_axis_tdata) && same;
    return same;
endfunction


function string m_dut_sequence_item::convert2string();
    string s;
    s = $sformatf("m_axis_tdata = %d", m_axis_tdata);
    return s;
endfunction