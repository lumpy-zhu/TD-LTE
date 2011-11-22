function [rs_data LTE_link_params] = LTE_Add_RS(LTE_common_params, LTE_link_params, rs_mode, tx_data)
if LTE_link_params.controller == 1
    switch rs_mode
        case 'URS'
            [rs_data LTE_link_params] =  LTE_Add_URS(LTE_common_params, LTE_link_params, tx_data);
        case 'CSI'
            [rs_data LTE_link_params] =  LTE_Add_CSI(LTE_common_params, LTE_link_params, tx_data);
        case 'CRS'
            [rs_data LTE_link_params] =  LTE_Add_CRS(LTE_common_params, LTE_link_params, tx_data);
        case 'DMRS'
            [rs_data LTE_link_params] = LTE_Add_DMRS(LTE_common_params, LTE_link_params, tx_data);
        case 'SRS'
            [rs_data LTE_link_params] = LTE_Add_SRS(LTE_common_params, LTE_link_params);
    end
else
    rs_data = tx_data;
end