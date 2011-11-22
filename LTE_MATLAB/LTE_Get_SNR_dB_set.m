function LTE_simu_params = LTE_Get_SNR_dB_set(ii_MCS, LTE_simu_params)
LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [];
LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [];
LTE_simu_params.N_SNR = 1;
%%% for UL(e+epa) %%% IA
% switch ii_MCS
%     case 1
%         LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-10:2.22:10];%[-12:1.35:7];%-12:7
%     case 2 
%         LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-8:2.22:12];%[-10:1.28:8];%-10:8
%     case 3
%         LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-6:2.22:14];%-5:13
%     case 4
%         LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-4:2.77:21];%-6:20
%         case 5
%         LTE_simu_params.UL_SNR_dB_set{ii_MCS} =[80]; %1:27
% %     case 5
% %         LTE_simu_params.UL_SNR_dB_set{ii_MCS} =[1:2.55:24]; %%0:17
%     case 6
%         LTE_simu_params.UL_SNR_dB_set{ii_MCS} =[80]; %1:27
% %     case 7
% %         LTE_simu_params.UL_SNR_dB_set{ii_MCS} =[42]; % 6:36
% end
% 
% %%% for DL(e+epa) %%%  IA
% switch ii_MCS
%     case 1
%         LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [-7:2.22:13];%[-9:1.28:9];%-9:9
%     case 2
%         LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [-5:2.44:17];%[-7:1.28:11];%-7:11
%     case 3
%         LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [-4:2.44:18];%-5:16
%     case 4
%         LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [4:2.22:24];%4:22
% %     case 5
% %         LTE_simu_params.DL_SNR_dB_set{ii_MCS} =[5:2.66:29];% 3:20
%         case 5
%         LTE_simu_params.DL_SNR_dB_set{ii_MCS} =[80]; %1:27
%     case 6
%         LTE_simu_params.DL_SNR_dB_set{ii_MCS} =[80]; %5:30
% %     case 7
% %         LTE_simu_params.DL_SNR_dB_set{ii_MCS} =[48]; %9:40
% end
%%% for UL(e+epa) %%% TD_MU_MIMO_BF
switch ii_MCS
    case 1
        LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-10:1.88:7];%
    case 2
        LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-8:1.88:9];%
    case 3
        LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-5:2:13];%
    case 4
        LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-4:2.22:16]; %-4 16
    case 5
        LTE_simu_params.UL_SNR_dB_set{ii_MCS} = [-2:2.44:20];%-2 20
    case 6
        LTE_simu_params.UL_SNR_dB_set{ii_MCS} = 80;%[1:2.55:24]; %1:24
end

%%% for DL(e+epa) %%%  TD_MU_MIMO_BF
switch ii_MCS
    case 1
        LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [-8:2:10];%
    case 2
        LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [-5:2:13];%
    case 3
        LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [-3:2.33:18];%
    case 4
        LTE_simu_params.DL_SNR_dB_set{ii_MCS} =[-1:2.55:22] ;%-1:22
    case 5
        LTE_simu_params.DL_SNR_dB_set{ii_MCS} = [2:3.11:30];%
    case 6
        LTE_simu_params.DL_SNR_dB_set{ii_MCS} = 80;%[5:3.33:35]; %5:
end
