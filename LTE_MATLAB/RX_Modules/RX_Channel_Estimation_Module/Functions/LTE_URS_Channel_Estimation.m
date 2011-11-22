function HP = LTE_URS_Channel_Estimation(rx_data_RF, LTE_common_params, LTE_link_params)
idx_bs = LTE_link_params.idx_bs;
idx_ms = LTE_link_params.idx_ms;
grid_urs = LTE_link_params.RS.grid_urs;
r_urs = LTE_link_params.RS.r_urs;
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;


[N_r N_SubC N_OFDM] = size(rx_data_RF);
HP = zeros(N_r,N_BS*N_MS, N_SubC, N_OFDM);
sym = get_pos(mean(grid_urs{1,1}));
w_p = [ 1 1 1 1;
    1 -1 1 -1;
    1 1 1 1;
    1 -1 1 -1;
    1 1 -1 -1;
    -1 -1 1 1;
    1 -1 -1 1;
    -1 1 1 -1];
row = size(w_p,1);
wp = zeros(row, N_OFDM);
wp(:,sym) = w_p;
% wp = [0 0 0 0 0 1 1 0 0 0 0 0 1 1;
%     0 0 0 0 0 1 -1 0 0 0 0 0 1 -1;
%     0 0 0 0 0 1 1 0 0 0 0 0 1 1;
%     0 0 0 0 0 1 -1 0 0 0 0 0 1 -1;
%     0 0 0 0 0 1 1 0 0 0 0 0 -1 -1;
%     0 0 0 0 0 -1 -1 0 0 0 0 0 1 1;
%     0 0 0 0 0 1 -1 0 0 0 0 0 -1 1;
%     0 0 0 0 0 -1 1 0 0 0 0 0 1 -1];
temp = (idx_bs-1)*N_MS+idx_ms;
seq_matrix = get_seq(N_BS, N_MS);
seq = seq_matrix(:,temp);
% switch index
%     case 1
%         seq = [1 2 3 4];
%     case 2
%         seq = [2 1 4 3];
%     case 3
%         seq = [3 4 1 2];
%     case 4
%         seq = [4 3 2 1];
% end
for i = 1:N_BS
    for j =1:N_MS
        x = grid_urs{i,j};
        r = r_urs{i,j};
        y = zeros(size(x));
        for i_nr = 1:N_r
            y(:,:) = rx_data_RF(i_nr,:,:);
            y(x==0)=0;
            h_temp = zeros(size(x));
            for k = 1:N_SubC
                temp = conj(r(k,:).*wp((i-1)*N_MS+j,:));
                h_temp(k,:) = sum(y(k,:).*temp)/sum(x(k,:).*temp+eps);
            end
            %             h_temp(x == 0) = 0;
            for symbol = sym
                h_temp(:,symbol) = transpose(interp1(find(h_temp(:,symbol)),h_temp(find(h_temp(:,symbol)),symbol),1:N_SubC, 'linear', 'extrap'));
            end
            h = transpose(interp1(sym,transpose(h_temp(:,sym)),1:N_OFDM,'linear', 'extrap'));
            HP(i_nr,seq((i-1)*N_MS+j),:,:) = h;
        end
    end
end

% LTE_link_params.HP{idx_bs,idx_ms} = HP;