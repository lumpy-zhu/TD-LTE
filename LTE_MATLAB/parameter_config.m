LTE_common_params.frm_str ='DSUUDDSUUD';   %'DSUUDDSUUD';
LTE_link_params.controller = 1;
LTE_common_params.i_frm_sp = 1; % position of the first special subfrm in a frm;
LTE_link_params.N_frames = 100;
% LTE_simu_params.SNR_dB_set{1} = 80;
% LTE_simu_params.current_SNR = LTE_simu_params.SNR_dB_set{1};
LTE_common_params.N_SubC_p_group = 12;
LTE_common_params.duplex_mode = 'TDD';
LTE_common_params.N_OFDM_p_subframe = 14;
LTE_common_params.N_OFDM_p_frame = 140;
LTE_common_params.BandWidth = 20e6;
LTE_common_params.N_SubC_Total = 1024;
LTE_common_params.N_SubC_p_RB = 12;
LTE_common_params.N_OFDM_p_RB = 7;
LTE_common_params.N_Max_RB = 110;
LTE_common_params.N_slot_p_frame = 20;
LTE_common_params.N_Symbol_p_RB = LTE_common_params.N_SubC_p_RB * LTE_common_params.N_OFDM_p_RB;
LTE_common_params.LTE_NULL = 3;
LTE_common_params.TC_interleaver_table = LTE_Gen_Interleaver_Tables();
LTE_common_params.N_cp = 1;
LTE_link_params.N_SubC_p_group = 12;
LTE_link_params.data_source_type = 'random binary';
LTE_link_params.coding_type = 'turbo codes';
LTE_link_params.scrambling_type = 'scrambling';
LTE_link_params.MCS_index = 1;
LTE_link_params.MCS_params = gen_FDD_MCS_params(LTE_link_params.MCS_index,gen_MCS_params);
LTE_link_params.MCS_params.TC_decoding_max_iterations = 8;
LTE_link_params.N_assigned_RB_p_Layer = 30;
LTE_link_params.N_assigned_SubC_p_Layer = LTE_link_params.N_assigned_RB_p_Layer * LTE_common_params.N_SubC_p_RB / 2;
LTE_link_params.N_Symbol_OtherChannel = 0;
%LTE_link_params.link_type = 'DL';
LTE_link_params.redundency_version = 0;

LTE_common_params.N_BS = 2;
LTE_common_params.N_MS = 2;

%% here we should be careful, current implementation deos not support
%% arbitary antenna configurations. followings are possible:
% {tx_mode, N_antennaPorts, N_layers, N_codewords}
% {spatial multiplexing, 2, 2, 2}
% {spatial multiplexing, 2, 2, 2}
% {spatial multiplexing, 2, 2, 2}
% {spatial multiplexing, 2, 2, 2}
LTE_link_params.MIMO_params.N_codewords = 1;
LTE_link_params.MIMO_params.N_layers = 1;
LTE_link_params.MIMO_params.N_antennaPorts = 4;
LTE_link_params.MIMO_params.N_Tx = LTE_link_params.MIMO_params.N_antennaPorts;
LTE_link_params.MIMO_params.N_Rx = 2;
LTE_link_params.MIMO_params.tx_mode = 'Spatial_Multiplexing'; % {'SISO','Spatial_Multiplexing','Transmit_Diversity','MU_MIMO'}
LTE_link_params.MIMO_params.detect_mode = 'MMSE'; % {'MMSE','ZF'};

% if strcmp(LTE_link_params.MIMO_params.tx_mode,'MU_MIMO')
%     LTE_link_params.MIMO_params.MU_MIMO_tx_mode = 'multiple streams';
%     LTE_link_params.N_codewords = 4;
% end
% if strcmp(LTE_link_params.MIMO_params.tx_mode,'Transmit_Diversity')...
%         || strcmp(LTE_link_params.MIMO_params.tx_mode,'Spatial_Multiplexing')...
%         || strcmp(LTE_link_params.MIMO_params.tx_mode,'MU_MIMO')
%     LTE_link_params.MIMO_params.MIMO_precoding_mode = 'closed loop'; % {'open loop', 'closed loop'}
%     if strcmp(LTE_link_params.MIMO_params.tx_mode,'Spatial_Multiplexing')...
%             && strcmp(LTE_link_params.MIMO_params.MIMO_precoding_mode,'closed loop')
%         LTE_link_params.MIMO_params.CLSM_TDD_Precoding_Mode = 'SVD';
%     end
% end

K_MIMO = 2;
HARQ_processes = 8;
N_soft = 1e6 * HARQ_processes;
M_limit = 8;
N_IR = floor(N_soft / (K_MIMO*min(HARQ_processes,M_limit)));
LTE_link_params.N_IR = N_IR;

UE.n_RNTI = 3;
UE.velocity = 3;
eNodeB.n_cellID = 5;
LTE_channel_params.time_correlation = 'FastFading';
LTE_channel_params.channel_type = 'epa';
LTE_channel_params.antenna_correlation_type = 'medium';
LTE_channel_params.carrierFrequency = 2.6e9;      % carrier frequency
LTE_channel_params.ueVelocity = UE.velocity;  %speed at which we move


