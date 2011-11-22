function [bler ber] = LTE_Check_Info_Bits(a,a_r,i_cw,LTE_link_params,TC_control)
ber = sum(abs(a-a_r))/LTE_link_params.N_data_bits(i_cw);
switch LTE_link_params.coding_type
    case 'turbo codes'
        bler = sum(not(TC_control.check_crc_result))/TC_control.C;
    case 'no coding'
        bler = (ber~=0);
    otherwise
end