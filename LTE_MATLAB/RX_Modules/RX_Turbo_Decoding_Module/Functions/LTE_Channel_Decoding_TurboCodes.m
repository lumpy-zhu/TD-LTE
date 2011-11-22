function [decoded_bits TC_control] = LTE_Channel_Decoding_TurboCodes(f_r,LTE_common_params,LTE_link_params,TC_control)
e_r = LTE_Code_Block_DeConcatenation(f_r,TC_control);
d_r = cell(TC_control.C,1);
c_r = cell(TC_control.C,1);
for i=1:TC_control.C
    d_r{i} = LTE_RX_Rate_Matching(e_r{i}, i, LTE_link_params, TC_control);
    [c_r{i} TC_control] = LTE_Turbo_Decoding(d_r{i},i,LTE_common_params,LTE_link_params,TC_control);
end
b_r = LTE_Code_Block_Assembling(c_r,TC_control);
a_r = LTE_Remove_CRC(b_r,'24a');
decoded_bits = a_r;