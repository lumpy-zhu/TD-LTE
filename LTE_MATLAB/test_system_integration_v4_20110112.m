clear all
close all
clc
warning('off','MATLAB:oldPfileVersion')
% tic
%% configurations, here we test the parameters

addpath(genpath(pwd))

parameter_config

% if exist('matlabpool')
%     matlabpool local 4
    for ii_MCS =6
        
        ii_MCS
        
        [LTE_link_params LTE_simu_params] = MCS_SNR_Initialization(ii_MCS, LTE_link_params);
        var.DL_SNR{ii_MCS} = LTE_simu_params.DL_SNR_dB_set{ii_MCS};
        var.UL_SNR{ii_MCS} = LTE_simu_params.UL_SNR_dB_set{ii_MCS};
        
        for nn = 1:LTE_simu_params.N_SNR
            nn
            tic
            LTE_simu_params.current_SNR_DL = LTE_simu_params.DL_SNR_dB_set{ii_MCS}(nn);
            LTE_simu_params.current_SNR_UL = LTE_simu_params.UL_SNR_dB_set{ii_MCS}(nn);
            N_frames = LTE_link_params.N_frames;
            for frm = 1:N_frames
                result(nn,ii_MCS,frm) = LTE_Frm_TX_RX(eNodeB, UE, LTE_common_params, LTE_link_params, LTE_simu_params, LTE_channel_params,frm);
            end
            toc
            var = LTE_Results_Analysis(ii_MCS, nn, N_frames, result, var);
            save results.mat var;
        end
    end
%     matlabpool close
% end

save results.mat var;
%     clear LTE*
% toc
%%
%     N_BS = LTE_common_params.N_BS;
%     N_MS = LTE_common_params.N_MS;
for ii_MCS =6
    DL_SNR = var.DL_SNR{ii_MCS};
    UL_SNR = var.UL_SNR{ii_MCS};
    for index =1:4 %N_BS*N_MS
        dl_bler = var.dl_bler(:,ii_MCS,index);
        dl_ber = var.dl_ber(:,ii_MCS,index);
        ul_bler = var.ul_bler(:,ii_MCS,index);
        ul_ber = var.ul_ber(:,ii_MCS,index);
        
        dl_throughput = var.dl_throughput(:,ii_MCS,index);
        ul_throughput = var.ul_throughput(:,ii_MCS,index);
        
%         dl_bler
%         ul_bler
        
                figure(index)
                grid on;
                hold on;
                title('UL')
                plot(UL_SNR, ul_throughput);
        
                figure(index+4)
                grid on;
                hold on;
                title('DL')
                plot(DL_SNR, dl_throughput);
        
        %         figure(index+8)
        %         grid on;
        %         hold on;
        %         title('UL')
        %         semilogy(UL_SNR, ul_bler);
        %
        %         figure(index+12)
        %         grid on;
        %         hold on;
        %         title('DL')
        %         semilogy(DL_SNR, dl_bler);
    end
end
%%
warning('on','MATLAB:oldPfileVersion')
