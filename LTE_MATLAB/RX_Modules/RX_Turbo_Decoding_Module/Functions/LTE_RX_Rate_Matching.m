function [data_o w_o]= LTE_RX_Rate_Matching(d_i, block_idx, LTE_LINK_params, TC_control)

len = TC_control.CB_sizes(block_idx) + 4;
C = TC_control.C;
punch_pos = TC_control.punch_pos{block_idx};
bit_NULL = 0;

C_TC_sub=32;%constant
R_TC_sub=floor(len/C_TC_sub)+1;
K_pi=C_TC_sub*R_TC_sub;
K_w=3*K_pi;

switch LTE_LINK_params.link_type
    case 'UL'
        N_cb=K_w;
    case {'DL', 'SP'}
        N_cb=min(floor(LTE_LINK_params.N_IR/C),K_w);
    otherwise
        disp('Link type error!');
end
k0=R_TC_sub*( 2*(floor(N_cb/8/R_TC_sub)+1)*LTE_LINK_params.redundency_version+2);

% %De puncture
% w_o(1:K_w)=bit_NULL;
% unpun_pos=setdiff(1:K_w,punch_pos);
% 
% E_pos=[unpun_pos(find(unpun_pos>k0)),unpun_pos(find(unpun_pos<=k0))];
% w_o(E_pos)=d_i(1:length(E_pos));
% if N_cb<K_w
%     w_o(N_cb+1:K_w)=bit_NULL; %make up the bits that are discarded.
% end

w_o(1:K_w) = bit_NULL;
unpun_pos=setdiff(1:N_cb,punch_pos);
N_UP = length(unpun_pos);
N_d = length(d_i);
N_R = ceil(N_d/N_UP);
d_tmp(1:N_UP*N_R) = bit_NULL;
d_tmp(1:N_d) = d_i;
d_i_combined = sum(reshape(d_tmp,[N_UP,N_R]),2);
% d_i_combined_tmp = reshape(d_tmp,[N_UP,N_R]);
% d_i_combined = d_i_combined_tmp(:,1);
E_pos=[unpun_pos(unpun_pos>k0),unpun_pos(unpun_pos<=k0)];
w_o(E_pos)=d_i_combined(1:length(E_pos));

v1=w_o(1:K_pi);
v2=w_o(K_pi+1:2:K_w);
v3=w_o(K_pi+2:2:K_w);

data_o =[LTE_RX_Sub_Interleaving(v1,len,1);LTE_RX_Sub_Interleaving(v2,len,2);LTE_RX_Sub_Interleaving(v3,len,3)];


