function [e_o, TC_control] = LTE_TX_Rate_Matching(d_i, block_idx, LTE_params_common, LTE_LINK_params, TC_control)

C = TC_control.C;
LTE_NULL = LTE_params_common.LTE_NULL;
len = size(d_i,2);
E = TC_control.E(block_idx);
C_TC_sub=32; %constant

R_TC_sub=floor(len/C_TC_sub)+1;
K_pi=C_TC_sub*R_TC_sub;
K_w=3*K_pi;
%--------------------------------------
%step 1- subinterleaver
v1=LTE_TX_Sub_Interleaving(d_i(1,:),1,len,LTE_NULL);
v2=LTE_TX_Sub_Interleaving(d_i(2,:),2,len,LTE_NULL);
v3=LTE_TX_Sub_Interleaving(d_i(3,:),3,len,LTE_NULL);
%----------------------------------------
%step 2- bit collection
w(1:K_pi)=v1;
w(K_pi+1:2:K_w)=v2;
w(K_pi+2:2:K_w)=v3;
%---------------------------------------- 
%step 3: bit selection and pruning
%get the punch position and length
switch LTE_LINK_params.link_type
    case 'UL'          % for uplink transmission
        N_cb=K_w;
    case {'DL', 'SP'}         % for downlink transmission
        N_cb=min(floor(LTE_LINK_params.N_IR/C),K_w);
    otherwise
        disp('Link type error!');
end
k0=R_TC_sub*( 2*(floor(N_cb/8/R_TC_sub)+1)*LTE_LINK_params.redundency_version+2);

%bit selection
Un_null_pos=find(w(1:N_cb)~=LTE_NULL);
w_index=[Un_null_pos(Un_null_pos>k0),Un_null_pos(Un_null_pos<=k0)];
idx_start = 1;
E_rest = E;
L_CyclicBuffer = length(w_index);
flag_punch = 0;
while L_CyclicBuffer < E_rest
    idx_end = idx_start + L_CyclicBuffer - 1;
    e_o(idx_start:idx_end) = w(w_index);
    idx_start = idx_end + 1;
    E_rest = E_rest - L_CyclicBuffer;
    punch_pos=setdiff(1:K_w,w_index);
    flag_punch = 1;
end
idx_end = idx_start + E_rest - 1;
e_o(idx_start:idx_end) = w(w_index(1:E_rest));
if flag_punch == 0
    punch_pos=setdiff(1:K_w,w_index(1:E));  
end
len_pun = length(punch_pos);
TC_control.punch_pos{block_idx} = punch_pos;
TC_control.len_pun(block_idx) = len_pun;