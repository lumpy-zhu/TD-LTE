function LTE_link_params = LTE_Channel_DeMapping(LTE_link_params)
PRB_non_data_pattern = repmat(LTE_link_params.RS_mapping_p_PRBpair,[LTE_link_params.N_assigned_RB_p_Layer/2 1]);
PRB_channel = LTE_link_params.channel.H_FFT;
demapped_channel = zeros(LTE_link_params.MIMO_params.N_Rx, LTE_link_params.MIMO_params.N_Tx, numel(PRB_non_data_pattern) - sum(PRB_non_data_pattern(:)));
for i = 1 : LTE_link_params.MIMO_params.N_Rx
    for j = 1 : LTE_link_params.MIMO_params.N_Tx
        tmp = PRB_channel(:,:,i,j);
        demapped_channel(i,j,:) = tmp(PRB_non_data_pattern == 0);
    end
end
LTE_link_params.channel.demapped_channel = demapped_channel;