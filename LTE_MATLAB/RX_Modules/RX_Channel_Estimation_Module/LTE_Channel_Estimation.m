function H_est = LTE_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params, est_mod)
if LTE_link_params.controller == 1
    switch est_mod
        case 'SRS'
            H_est = LTE_SRS_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params);
        case 'UL'
            H_est = LTE_DMRS_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params);
        case 'DL'
            H_est = LTE_URS_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params);
        case 'csi'
            H_est = LTE_CSI_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params);
    end
else
    H_est = 0;
end