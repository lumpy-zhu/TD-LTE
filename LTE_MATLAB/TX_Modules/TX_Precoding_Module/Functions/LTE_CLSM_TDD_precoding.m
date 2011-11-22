function [tx_data_precoded precodingMatrix H_CSI_data] = LTE_CLSM_TDD_precoding(tx_data_layered, LTE_link_params)
MIMO_params = LTE_link_params.MIMO_params;
N_AP = MIMO_params.N_antennaPorts;
N_L = MIMO_params.N_layers;
L_data = size(tx_data_layered{1,1},2);
[N_SubC N_Symbol N_Rx N_Tx] = size(MIMO_params.H_CSI_est{1,1,1});

H_CSI = shiftdim(reshape(MIMO_params.H_CSI_est{:,:,:},[N_SubC*N_Symbol, N_Rx, N_Tx]),1);
PRB_non_data_pattern = repmat(LTE_link_params.RS_mapping_p_PRBpair,[LTE_link_params.N_assigned_RB_p_Layer/2 1]);
H_CSI_data = H_CSI(:,:,PRB_non_data_pattern==0);
switch MIMO_params.CLSM_TDD_Precoding_Mode
    case 'SVD'
        precodingMatrix = zeros(N_AP,N_L,L_data);
        tx_data_precoded = zeros(N_AP,L_data);
        for i = 1:L_data
            [U S V] = svd(H_CSI_data(:,:,i));
            precodingMatrix(:,:,i) = V(:,1:N_L);
            tx_data_precoded(:,i) = precodingMatrix(:,:,i)*tx_data_layered(:,i);
        end         
    otherwise
        error('closed loop TDD precoding mode is not supported!')
end