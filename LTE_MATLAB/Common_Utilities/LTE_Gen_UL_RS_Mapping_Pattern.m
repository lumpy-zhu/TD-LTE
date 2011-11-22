function LTE_link_params = LTE_Gen_UL_RS_Mapping_Pattern(LTE_common_params, LTE_link_params)

LTE_link_params.N_RS = 24*LTE_link_params.N_assigned_RB_p_Layer;
mapping = zeros(LTE_common_params.N_SubC_p_RB, 2*LTE_common_params.N_OFDM_p_RB);
mapping(:,[4 11]) = 1; % UL DMRS
mapping(:,[13 14]) = 1; % reserved for PUCCH, SRS and other purposes
LTE_link_params.RS_mapping_p_PRBpair = mapping;
%%%%%%%%
% N_slot = LTE_common_params.N_slot_p_frame;
% group_hopping_enabled = 1;
% sequence_hopping_enabled = 1;
% m_RB = LTE_link_params.N_assigned_RB_p_Layer/2;
% M_RS_sc = m_RB * LTE_common_params.N_SubC_p_RB;
% N_OFDM_p_RB = LTE_common_params.N_OFDM_p_RB ;
% N_OFDM_p_frame = LTE_common_params.N_OFDM_p_frame;
% N_assigned_SubC_p_Layer = LTE_link_params.N_assigned_SubC_p_Layer;
% N_cell = [0 1];
% dmrs_grid = zeros(N_assigned_SubC_p_Layer,N_OFDM_p_frame,length(N_cell));
% % initialization
% n_1_DMRS = 0;  %%%%
% n_2_DMRS = 0;  %%%%
% 
% deta_ss = 0;
% 
% for N_cell_ID = N_cell
%     c_init = floor(N_cell_ID/30);
%     c = gen_length31_gold_sequence(8*N_slot + 8, c_init);
%     for ns = 0:N_slot-1
%         if group_hopping_enabled
%             temp = 0;
%             for i =0:7
%                 temp = temp + c(8*ns+i+1) * 2^i;
%             end
%             f_gh(ns+1) = mod(temp,30);
%         else
%             f_gh(ns+1) = 0;
%         end
%         f_ss_pucch = mod(N_cell_ID, 30);
%         f_ss_pusch = mod(f_ss_pucch + deta_ss, 30);
%         u = mod(f_gh(ns+1)+f_ss_pusch, 30);
% 
% 
%         if(m_RB < 6)
%             v = 0;
%         else
%             if(~group_hopping_enabled && sequence_hopping_enabled)
%                 c_init = floor(N_cell_ID/30) * 2^5 + f_ss_pusch;
%                 c = gen_length31_gold_sequence(N_slot, c_init);
%                 v = c(ns+1);
%             else
%                 v = 0;
%             end
%         end
%         seq_len = M_RS_sc;
%         r_uv = LTE_Gen_Base_Sequence(seq_len,u,v);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%% gnerate DMRS
% 
%         c_init = floor(N_cell_ID/30) * 2^5 + f_ss_pusch;
%         c = gen_length31_gold_sequence(8*LTE_common_params.N_OFDM_p_RB*N_slot+8, c_init);
%         temp = 0;
%         for i =0:7
%             temp = temp + c(8*LTE_common_params.N_OFDM_p_RB*ns+i+1) * 2^i;
%         end
%         n_PRS(ns+1) = temp;
%         n_cs = mod(n_1_DMRS + n_2_DMRS + n_PRS(ns+1), 12);
%         alpha = 2*pi*n_cs/12;
%         n = 0:M_RS_sc-1;
%         r_alpha_uv = exp(j*alpha*n) .* r_uv;
%         %     for m = [0 1]
%         %         r_pusch( m*M_RS_sc + n+1) = r_alpha_uv(n+1);
%         %     end
%         dmrs_grid(:,ns*N_OFDM_p_RB + 4,N_cell_ID+1) = r_alpha_uv';
%     end
%     
% end
% LTE_link_params.dmrs_grid = dmrs_grid;
% 
% N_RB_sc = LTE_common_params.N_SubC_p_RB;
% 
% 
% n_cs_SRS = 2; %[0:7];
% C_SRS = 7;%[0:7];
% B_SRS = 1;%[0:3];
% k_TC = 0;%[0 1];
% b = B_SRS;
% alpha = 2*pi*n_cs_SRS/8;
% r_alpha_uv = exp(j*alpha*n) .* r_uv;
% r_SRS = r_alpha_uv;
% b_hop = 2; % [0:3];
% n_RRC = 1; % unsure
% 
% N_UL_RB = LTE_link_params.N_assigned_RB_p_Layer/2;
% N_UL_RB = 50;
% if (N_UL_RB>=6 &&N_UL_RB<=40)
%     m_SRS = [36 32 24 20 16 12 8 4;
%         12 16 4 4 4 4 4 4;
%         4 8 4 4 4 4 4 4;
%         4 4 4 4 4 4 4 4];
%     N = [1 1 1 1 1 1 1 1;
%         3 2 6 5 4 3 2 1;
%         3 2 1 1 1 1 1 1;
%         1 2 1 1 1 1 1 1];
%     
% elseif(N_UL_RB>40 &&N_UL_RB<=60)
%     m_SRS = [48 48 40 36 32 24 20 16;
%         24 16 20 12 16 4 4 4;
%         12 8 4 4 8 4 4 4;
%         4 4 4 4 4 4 4 4];
%     N = [1 1 1 1 1 1 1 1;
%         2 3 2 3 2 6 5 4;
%         2 2 5 3 2 1 1 1;
%         3 2 1 1 2 1 1 1];
%     
% elseif(N_UL_RB>60 &&N_UL_RB<=80)
%     m_SRS = [72 64 60 48 48 40 36 32;
%         24 32 20 24 16 20 12 16;
%         12 16 4 12 8 4 4 8;
%         4 4 4 4 4 4 4 4];
%     N = [1 1 1 1 1 1 1 1;
%         3 2 3 2 3 2 3 2;
%         2 2 5 2 2 5 3 2;
%         3 4 1 3 2 1 1 2];
%     
% elseif(N_UL_RB>80 &&N_UL_RB<=110)
%     m_SRS = [96 96 80 72 64 60 48 48;
%         48 32 40 24 32 20 24 16;
%         24 16 20 12 16 4 12 8;
%         4 4 4 4 4 4 4 4];
%     N = [1 1 1 1 1 1 1 1;
%         2 3 2 3 2 3 2 3;
%         2 2 2 2 2 5 2 2;
%         4 4 4 4 4 4 4 4];
%     
% end
% temp = 0;
% for b = 0:B_SRS
%     m_SRS_b = m_SRS(b+1, C_SRS+1);
%     M_RS_sc_b = m_SRS_b * N_RB_sc /2;
%     N_b = N(b+1, C_SRS+1);
%     if(b_hop >= B_SRS)
%         n_b = mod(floor( 4 * n_RRC / m_SRS_b), N_b);
%     else
%        n_SRS = floor(nf *10 + floor(ns/2)/T_SRS);
%        II = 1;
%        for b_p = b_hop+1 : b
%            II = II * N(b_p+1,C_SRS+1);
%        end
%        if mod(N_b,2)
%            F_b = floor(N_b/2) * floor(n_SRS/II);
%        else
%            F_b = N_b/2 * floor(mod(n_SRS,II) / II) + floor(mod(n_SRS,II) /2/II);
%        end
%         n_b = mod(F_b + floor(4*n_RRC/m_SRS_b),N_b);   
%     end
%     temp = temp + 2*M_RS_sc_b*n_b;
% end
% 
% k_prime = 0:M_RS_sc_b-1;        
% k0_prime = (floor(N_UL_RB/2) - m_SRS(1,C_SRS+1)/2) * N_RB_sc + k_TC;
% k0 = k0_prime + temp;
% for l = 7
% grid(2*k_prime+k0+1, l) = r_SRS(k_prime+1);
% end


























