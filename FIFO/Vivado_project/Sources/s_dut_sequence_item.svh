class s_dut_sequence_item #(int VAR_WIDTH = 16) extends uvm_sequence_item;
    `uvm_object_param_utils(s_dut_sequence_item #(VAR_WIDTH))

    rand bit [VAR_WIDTH-1:0] s_axis_tdata;
    rand bit s_axis_tvalid[];

    constraint c_s_axis_tdata{
        s_axis_tdata inside {[0:{$size(s_axis_tdata){1'b1}}]};
    }

    constraint c_s_axis_tvalid{
        foreach (s_axis_tvalid[i])
            s_axis_tvalid[i] inside {[0:1]};
        s_axis_tvalid.size inside {[3:3]};
        s_axis_tvalid.sum == 1;
    }

    extern function new (string name = "s_dut_sequence_item"); 
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string(); 
endclass


function s_dut_sequence_item::new (string name = "s_dut_sequence_item"); 
    super.new(name);
endfunction


function bit s_dut_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    s_dut_sequence_item #(VAR_WIDTH) rhs_inst;
    bit same;
    same = super.do_compare(rhs, comparer);
    $cast(rhs_inst, rhs);
    same = (s_axis_tdata == rhs_inst.s_axis_tdata) && same;
    return same;
endfunction


function string s_dut_sequence_item::convert2string();
    string s;
    s = $sformatf("s_axis_tdata = %d", s_axis_tdata);
    return s;
endfunction