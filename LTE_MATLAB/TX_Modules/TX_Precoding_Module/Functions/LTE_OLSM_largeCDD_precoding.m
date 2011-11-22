function [tx_data_precoded precodingMatrix] = LTE_OLSM_largeCDD_precoding(tx_data_layered, MIMO_params)
N_AP = MIMO_params.N_antennaPorts;
N_L = MIMO_params.N_layers;
U = MIMO_params.U_largeCDD{N_L};
D = MIMO_params.D_largeCDD{N_L};
switch N_AP
    case 2
        W = MIMO_params.W2{N_L}(:,:,1);
        precodingMatrix = zeros(N_AP,N_L,2);
        precodingMatrix(:,:,1) = W*D*U;
        precodingMatrix(:,:,2) = W*D^2*U;
        y1 = precodingMatrix(:,:,1)*tx_data_layered(:,1:2:end);
        y2 = precodingMatrix(:,:,2)*tx_data_layered(:,2:2:end);
        tx_data_precoded = reshape([y1;y2],N_L,[]);
    case 4
        W = zeros(4,N_L,4);
        for ii = 13:16
            W(:,:,ii-12) = 1/sqrt(N_L) * MIMO_params.W4(:,MIMO_params.W4mapping{N_L}(ii,:),ii);
        end
        l = 1:size(tx_data_layered,2);
        k = mod(floor((l-1)/N_L),4)+1;
        p = mod(l-1,N_L)+1;
        period = lcm(seqperiod(k),seqperiod(p));
        precodingMatrix = zeros(N_AP,N_L,period);
        tx_data_precoded = zeros(N_AP,size(tx_data_layered,2));
        for i = 1:period
            precodingMatrix(:,:,i)= W(:,:,k(i))*D*U;
            temp = precodingMatrix(:,:,i)*tx_data_layered(:,i:period:end);
            tx_data_precoded(:,i:period:size(temp,2)*period) = temp;
        end
end