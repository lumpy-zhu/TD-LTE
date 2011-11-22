function HP = LTE_DMRS_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params)
i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
r_dmrs = LTE_link_params.RS.r_dmrs;
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;

[N_r N_SubC N_OFDM] = size(rx_data_RF);
r1 = r_dmrs{1};
r2 = r_dmrs{2};

flag = 1;
layer_num = N_MS;
fft_size = floor(1024/layer_num/flag) * layer_num * flag;
start_idx = -floor( fft_size/layer_num/flag/6 );
end_idx = floor( fft_size/layer_num/flag/5 );

HP = zeros(N_r,N_BS*N_MS,N_SubC,N_OFDM);
temp = (i-1)*N_MS+j;
seq_matrix = get_seq(N_BS, N_MS);
seq = seq_matrix(:,temp);
% switch temp
%     case 1
%         seq = [1 2 3 4];
%     case 2
%         seq = [2 1 4 3];
%     case 3
%         seq = [3 4 1 2];
%     case 4
%         seq = [4 3 2 1];
% end
for n_r = 1:N_r
    ya = rx_data_RF(n_r,:,4);
    yb = rx_data_RF(n_r,:,11);
    y1 = (ya + yb)/2;
    y2 = (ya - yb)/2;
    Ha = dft_est(transpose(y1),transpose(r1),fft_size, start_idx, end_idx, layer_num, flag);
    Hb = dft_est(transpose(y2),transpose(r2),fft_size, start_idx, end_idx, layer_num, flag);
    H_temp = [Ha;Hb];
    HP(n_r,:,:,:) = repmat(exchange(H_temp, seq),[1 1 14]);  
end

% LTE_link_params.HP{i,j} = HP;
% Y_ul{i,j} = H{i,i,j}*X{i,j} + H{i,i,3-j}*X{i,3-j} + H{i,3-i,j}*X{3-i,j} + H{i,3-i,3-j}*X{3-i,3-j};
   