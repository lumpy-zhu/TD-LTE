function rx_detected_data = LTE_MIMO_Detection(rx_data_RF, LTE_link_params, H_est)
% i = LTE_link_params.idx_bs;
% j = LTE_link_params.idx_ms;
% [N_r N_SubC N_OFDM] = size(rx_data_RF);
% G_IA = LTE_link_params.G_IA{i,j};
% rx_detected_data = zeros(N_SubC, N_OFDM);
%
% P = LTE_link_params.P_IA;
% H = LTE_link_params.MIMO_params.H_CSI_est;
%
%
% % Y_dl{i,j} = H{i,i,j}*X{i,j} + H{i,i,j}*X{i,3-j} + H{3-i,i,j}*X{3-i,j} + H{3-i,i,j}*X{3-i,3-j};
% % Y_ul{i,j} = H{i,i,j}*X{i,j} + H{i,i,3-j}*X{i,3-j} + H{i,3-i,j}*X{3-i,j} + H{i,3-i,3-j}*X{3-i,3-j};
% for n_subc = 1:N_SubC
%     for n_ofdm = 1:N_OFDM
%         G = G_IA(:,:,n_subc,n_ofdm);
%         x = G*rx_data_RF(:,n_subc,n_ofdm);
%         if LTE_link_params.controller == 1
%             HP = H_est(:,:,n_subc,n_ofdm);
%         else
%             if strcmp(LTE_link_params.link_type,'DL')
%                 HP(:,1) = H{i,i,j}(:,:,n_subc,n_ofdm)*P{i,j}(:,1,n_subc,n_ofdm);
%                 HP(:,2) = H{i,i,j}(:,:,n_subc,n_ofdm)*P{i,3-j}(:,1,n_subc,n_ofdm);
%                 HP(:,3) = H{3-i,i,j}(:,:,n_subc,n_ofdm)*P{3-i,j}(:,1,n_subc,n_ofdm);
%                 HP(:,4) = H{3-i,i,j}(:,:,n_subc,n_ofdm)*P{3-i,3-j}(:,1,n_subc,n_ofdm);
%
%             elseif strcmp(LTE_link_params.link_type,'UL')
%                 HP(:,1) = H{i,i,j}(:,:,n_subc,n_ofdm)*P{i,j}(:,1,n_subc,n_ofdm);
%                 HP(:,2) = H{i,i,3-j}(:,:,n_subc,n_ofdm)*P{i,3-j}(:,1,n_subc,n_ofdm);
%                 HP(:,3) = H{i,3-i,j}(:,:,n_subc,n_ofdm)*P{3-i,j}(:,1,n_subc,n_ofdm);
%                 HP(:,4) = H{i,3-i,3-j}(:,:,n_subc,n_ofdm)*P{3-i,3-j}(:,1,n_subc,n_ofdm);
%             end
%         end
%         GHP = G*HP;
%         rx_detected_data(n_subc,n_ofdm) =  1/(GHP*GHP'+G*G'*LTE_link_params.channel.noise_pwr)* GHP(:,1)'*x;
%     end
% end




i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
[N_r N_SubC N_OFDM] = size(rx_data_RF);
G_IA = LTE_link_params.G_IA{i,j};
% rx_detected_data = zeros(N_SubC, N_OFDM);

% Y_dl{i,j} = H{i,i,j}*X{i,j} + H{i,i,j}*X{i,3-j} + H{3-i,i,j}*X{3-i,j} + H{3-i,i,j}*X{3-i,3-j};
% Y_ul{i,j} = H{i,i,j}*X{i,j} + H{i,i,3-j}*X{i,3-j} + H{i,3-i,j}*X{3-i,j} + H{i,3-i,3-j}*X{3-i,3-j};
if LTE_link_params.controller == 1
    HP = H_est;
else
    HP = zeros(N_r,4,N_SubC,N_OFDM);
    P = LTE_link_params.P_IA;
    H = LTE_link_params.MIMO_params.H_CSI_est;
    N_t = size(P{i,j},1);
    if strcmp(LTE_link_params.link_type,'DL')
        % 1
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{i,i,j}(ii,jj,:,:).*P{i,j}(jj,1,:,:));
            end
            HP(ii,1,:,:) = H_tmp;
        end
        % 2
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{i,i,j}(ii,jj,:,:).*P{i,3-j}(jj,1,:,:));
            end
            HP(ii,2,:,:) = H_tmp;
        end
        % 3
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{3-i,i,j}(ii,jj,:,:).*P{3-i,j}(jj,1,:,:));
            end
            HP(ii,3,:,:) = H_tmp;
        end
        % 4
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{3-i,i,j}(ii,jj,:,:).*P{3-i,3-j}(jj,1,:,:));
            end
            HP(ii,4,:,:) = H_tmp;
        end
    elseif strcmp(LTE_link_params.link_type,'UL')
        % 1
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{i,i,j}(ii,jj,:,:).*P{i,j}(jj,1,:,:));
            end
            HP(ii,1,:,:) = H_tmp;
        end
        % 2
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{i,i,3-j}(ii,jj,:,:).*P{i,3-j}(jj,1,:,:));
            end
            HP(ii,2,:,:) = H_tmp;
        end
        % 3
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{i,3-i,j}(ii,jj,:,:).*P{3-i,j}(jj,1,:,:));
            end
            HP(ii,3,:,:) = H_tmp;
        end
        % 4
        for ii = 1:N_r
            H_tmp = zeros(N_SubC,N_OFDM);
            for jj = 1:N_t
                H_tmp = H_tmp + squeeze(H{i,3-i,j}(ii,jj,:,:).*P{3-i,3-j}(jj,1,:,:));
            end
            HP(ii,4,:,:) = H_tmp;
        end
    end
end

x = zeros(N_SubC,N_OFDM);
for ii = 1:N_r
    x = x + squeeze(G_IA(:,ii,:,:)).*squeeze(rx_data_RF(ii,:,:));
end

GHP = zeros(4,N_SubC,N_OFDM);
for jj = 1:4
    GHP_tmp = zeros(N_SubC,N_OFDM);
    for ii = 1:N_r
        GHP_tmp = GHP_tmp + squeeze(G_IA(:,ii,:,:)).*squeeze(HP(ii,jj,:,:));
    end
    GHP(jj,:,:) = GHP_tmp;
end

GHPPHG = zeros(N_SubC,N_OFDM);
for ii = 1:4
    GHPPHG = GHPPHG + squeeze(GHP(ii,:,:).*conj(GHP(ii,:,:)));
end
GG = zeros(N_SubC,N_OFDM);
for ii = 1:N_r
    GG = GG + squeeze(G_IA(:,ii,:,:).*conj(G_IA(:,ii,:,:)));
end
% if strcmp(LTE_link_params.link_type,'UL')
rx_detected_data =  1./(GHPPHG+GG*LTE_link_params.channel.noise_pwr).*conj(squeeze(GHP(1,:,:))).*x;
% else
%     rx_detected_data = x;
% end