function tx_PRB_mapped_data = LTE_Resource_Mapping(tx_layered_data,LTE_common_params,LTE_link_params)

tx_PRB_mapped_data = zeros(LTE_link_params.N_assigned_SubC_p_Layer,LTE_common_params.N_OFDM_p_subframe,1);
PRB_non_data_pattern = repmat(LTE_link_params.RS_mapping_p_PRBpair,[LTE_link_params.N_assigned_RB_p_Layer/2 1]);
for i = 1:1  %LTE_link_params.MIMO_params.N_antennaPorts
    tmp = zeros(LTE_link_params.N_assigned_SubC_p_Layer, LTE_common_params.N_OFDM_p_subframe);
    tmp(PRB_non_data_pattern==0) = tx_layered_data(i,:);
    tx_PRB_mapped_data(:,:,i) = tmp;
end