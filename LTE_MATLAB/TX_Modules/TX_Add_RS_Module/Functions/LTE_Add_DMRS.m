function [dmrs_data LTE_link_params] = LTE_Add_DMRS(LTE_common_params, LTE_link_params, tx_PRB_mapped_data)

i = LTE_link_params.idx_bs;
j = LTE_link_params.idx_ms;
n_subfrm = LTE_link_params.n_subfrm;
N_RB = LTE_link_params.N_assigned_RB_p_Layer/2;
N_MS = LTE_common_params.N_MS;

N_cell_ID = i-1;
ns = 2*n_subfrm;
[N_SubC N_OFDM] = size(tx_PRB_mapped_data);
N_OFDM_p_RB = N_OFDM/2;

dmrs_grid = zeros(N_SubC, N_OFDM);
switch N_cell_ID
    case 0
        w = [1 1];
    case 1
        w = [1 -1];
end

seq_len = N_SubC;
r_uv = LTE_Gen_Base_Sequence(N_cell_ID, ns, N_RB, seq_len);

n_cs = 0:N_MS-1;
t = n_cs(j);
alpha = 2*pi*t/N_MS;
n = 0:N_SubC-1;
r_alpha_uv = exp(1j*alpha*n) .* r_uv;

for m = [0 1]
   dmrs_grid(:,4+m*N_OFDM_p_RB)  = w(m+1)* transpose(r_alpha_uv);
end

dmrs_data = tx_PRB_mapped_data + dmrs_grid;
LTE_link_params.RS.r_dmrs{i} = r_uv;