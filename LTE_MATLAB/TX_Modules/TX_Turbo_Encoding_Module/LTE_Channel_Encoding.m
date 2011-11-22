function [coded_bits TC_control] = LTE_Channel_Encoding(a, i_cw, LTE_common_params, LTE_link_params)
TC_control = struct();
switch  LTE_link_params.coding_type
    case 'turbo codes'
        [coded_bits TC_control] = LTE_Channel_Encoding_TurboCodes(a, i_cw, LTE_common_params, LTE_link_params);
    case 'no coding'
        coded_bits = a;
    otherwise
end