function tx_precoded_data = LTE_Precoding(tx_PRB_mapped_data, LTE_link_params)
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
P_IA = LTE_link_params.P_IA{i,j};
[N_AT_BS x N_SubC N_OFDM] = size(P_IA);
tx_precoded_data = zeros(N_AT_BS, N_SubC, N_OFDM);
P_temp = zeros(N_SubC, N_OFDM);
for n_t = 1:LTE_link_params.MIMO_params.N_Tx
    P_temp(:,:) = P_IA(n_t,1,:,:);
    tx_precoded_data(n_t,:,:) = P_temp.*tx_PRB_mapped_data(:,:);
end

% [N_SubC N_OFDM N_AT_BS] = size(P_IA);
% for n_subc = 1:N_SubC
%     for n_ofdm = 1:N_OFDM
%         tx_precoded_data(n_subc,n_ofdm,:) = P_IA(n_subc,n_ofdm,:) * tx_PRB_mapped_data(n_subc,n_ofdm);
%     end
% end