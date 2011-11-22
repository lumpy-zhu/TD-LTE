function y = LTE_TD_precoding(x,MIMO_params)
N_AP = MIMO_params.N_antennaPorts;
switch N_AP
    case 2
        precodingMatrix = MIMO_params.TD_precodingMatrix2;
    case 4
        precodingMatrix = MIMO_params.TD_precodingMatrix4;
end
x_tmp = precodingMatrix * [real(x);imag(x)]; 
y = zeros(N_AP,size(x,2)*N_AP);
for i = 1:N_AP
    idx_AP = ((i-1)*N_AP + 1):(i*N_AP);
    y(:,i:N_AP:end) = x_tmp(idx_AP,:);
end
