function [decoded_bits TC_control] = LTE_Channel_Decoding(f_r,LTE_common_params,LTE_link_params,TC_control)
switch  LTE_link_params.coding_type
    case 'turbo codes'
        [decoded_bits TC_control] = LTE_Channel_Decoding_TurboCodes(f_r,LTE_common_params,LTE_link_params,TC_control);
    case 'no coding'
        decoded_bits = LTE_Hard_Decision(f_r);
    otherwise
end