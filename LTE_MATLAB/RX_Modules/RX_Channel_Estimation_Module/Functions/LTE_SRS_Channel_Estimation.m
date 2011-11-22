function H = LTE_SRS_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params)
r_srs = LTE_link_params.RS.r_srs;
[N_r N_SubC N_OFDM] = size(rx_data_RF{1,1});
N_MS = LTE_common_params.N_MS;
N_BS = LTE_common_params.N_BS;
N_Tx = LTE_link_params.MIMO_params.N_Tx;

flag = N_BS;
layer_num = N_MS*N_Tx;

fft_size = floor(1024/layer_num/flag)*layer_num*flag;
start_idx = -floor(fft_size/layer_num/flag/4);
end_idx = floor(fft_size/layer_num/flag/3);

l = N_OFDM;

H = cell(N_BS, N_BS, N_MS);

% Y_ul{i,j} = H{i,i,j}*X{i,j} + H{i,i,3-j}*X{i,3-j} + H{i,3-i,j}*X{3-i,j} + H{i,3-i,3-j}*X{3-i,3-j};
 j=1;
for i =1:2
    rx =  transpose(rx_data_RF{i,j}(:,:,l));
    r1 = transpose(r_srs{i});
    r2 = transpose(r_srs{3-i});
   
    for n_r = 1:N_r
        y = rx(:,n_r);
        H_a = dft_est(y, r1, fft_size, start_idx, end_idx, layer_num, flag);
        H{i,i,j}(:,n_r,:) = H_a(1:2,:);
        H{i,i,3-j}(:,n_r,:) = H_a(3:4,:);
        H_b = dft_est(y, r2, fft_size, start_idx, end_idx, layer_num, flag);
        H{i,3-i,j}(:,n_r,:) = H_b(1:2,:);
        H{i,3-i,3-j}(:,n_r,:) = H_b(3:4,:); 
    end
end