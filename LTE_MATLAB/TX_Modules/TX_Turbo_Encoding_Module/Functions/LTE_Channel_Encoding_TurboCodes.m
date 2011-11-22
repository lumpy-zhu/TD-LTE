function [coded_bits TC_control] = LTE_Channel_Encoding_TurboCodes(a, i_cw, LTE_common_params, LTE_link_params)
b = LTE_Append_CRC(a,'24a',LTE_common_params);
[c TC_control] = LTE_Code_Block_Segmentation(b,LTE_common_params);
gamma = mod(LTE_link_params.G_prime,TC_control.C);
% encoding block by block
d=cell(TC_control.C,1);
e=cell(TC_control.C,1);
for i=1:TC_control.C
    d{i} = LTE_Turbo_Encoding(c{i},LTE_common_params,i,TC_control);
    if i <= TC_control.C - gamma
        TC_control.E(i) = LTE_link_params.MIMO_params.N_layers*LTE_link_params.MCS_params.modulation_order*floor(LTE_link_params.G_prime(i_cw)/TC_control.C);
    else
        TC_control.E(i) = LTE_link_params.MIMO_params.N_layers*LTE_link_params.MCS_params.modulation_order*ceil(LTE_link_params.G_prime(i_cw)/TC_control.C);
    end
    [e{i}, TC_control] = LTE_TX_Rate_Matching(d{i},i,LTE_common_params,LTE_link_params, TC_control);
end
f = LTE_Code_Block_Concatenation(e);
coded_bits = f;