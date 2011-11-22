function rx_layered_data = LTE_Resource_DeMapping(rx_demapped_data,LTE_link_params)
PRB_non_data_pattern = repmat(LTE_link_params.RS_mapping_p_PRBpair,[LTE_link_params.N_assigned_RB_p_Layer/2 1]);

rx_layered_data = zeros(1,numel(PRB_non_data_pattern) - sum(PRB_non_data_pattern(:)));
tmp = rx_demapped_data(:,:);
rx_layered_data(1,:) = tmp(PRB_non_data_pattern == 0);
