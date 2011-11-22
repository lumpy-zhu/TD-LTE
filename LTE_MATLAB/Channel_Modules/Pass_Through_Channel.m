function [rx_data LTE_link_params] = Pass_Through_Channel(tx_data_RF, LTE_common_params, LTE_link_params, LTE_simu_params)
H = LTE_link_params.channel.H_FFT;
N_Tx = LTE_link_params.MIMO_params.N_Tx;
N_Rx = LTE_link_params.MIMO_params.N_Rx;
N_SubC = LTE_link_params.N_assigned_SubC_p_Layer;
N_OFDM = LTE_common_params.N_OFDM_p_subframe;
H_1 = zeros(N_SubC,N_OFDM);
X_1 = zeros(N_SubC,N_OFDM);
rx_data = cell(size(tx_data_RF));

noise_pwr = 10^(-LTE_simu_params.current_SNR/10);
% Y_dl{i,j} = H{i,i,j}*X{i,j} + H{i,i,j}*X{i,3-j} + H{3-i,i,j}*X{3-i,j} + H{3-i,i,j}*X{3-i,3-j};
% Y_ul{i,j} = H{i,i,j}*X{i,j} + H{i,i,3-j}*X{i,3-j} + H{i,3-i,j}*X{3-i,j} + H{i,3-i,3-j}*X{3-i,3-j};
for i = 1:LTE_common_params.N_BS
    for j = 1:LTE_common_params.N_MS
        rx_data{i,j} = zeros(N_Rx, N_SubC, N_OFDM);
        for n_r = 1:N_Rx
            for n_t = 1:N_Tx
                for ii = 1:LTE_common_params.N_BS
                    for jj = 1:LTE_common_params.N_MS
                        if strcmp(LTE_link_params.link_type,'DL')
                            H_1(:,:) = H{ii,i,j}(n_r,n_t,:,:);
                        else
                            H_1(:,:) = H{i,ii,jj}(n_r,n_t,:,:);
                        end
                        X_1(:,:) = tx_data_RF{ii,jj}(n_t,:,:);
                        rx_data{i,j}(n_r,:,:) = squeeze(rx_data{i,j}(n_r,:,:)) + H_1.*X_1;
                    end
                end
            end
        end
                rx_data{i,j} = rx_data{i,j} + sqrt(noise_pwr)*(randn(size(rx_data{i,j}))...
                    + 1i*randn(size(rx_data{i,j})))/sqrt(2);
    end
end

LTE_link_params.channel.noise_pwr = noise_pwr * eye(LTE_link_params.MIMO_params.N_layers);