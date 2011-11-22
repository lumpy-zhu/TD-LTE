function H_est = LTE_CSI_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params)
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
[N_r N_SubC N_OFDM] = size(rx_data_RF);
grid_csi = LTE_link_params.RS.grid_csi{i,j};
N_t = size(grid_csi, 1);
x = zeros(N_SubC, N_OFDM)

for n_r = 1:N_r
    y1 = squeeze(rx_data_RF(n_r,:,:));
    y2 = squeeze(rx_data_RF(n_r,:,:));
    for n_t = 1:N_t
        x(:,:) =  grid_csi(n_t,:,:);
        y1(x == 0) = 0;
        
    