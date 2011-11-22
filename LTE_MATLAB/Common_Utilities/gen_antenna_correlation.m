function R=gen_antenna_correlation(N_Tx,type)
V_alpha = [0 0.3 0.9];
if N_Tx==1
    R=1;
else
    switch type
        case 'low'
            a = 1;
        case 'medium'
            a = 2;
        case 'high'
            a = 3;
        case 'random'
            a = ceil(3*rand());
    end
    alpha = V_alpha(a);
    R=toeplitz(alpha.^(((0:(N_Tx-1)).^2)/((N_Tx-1)^2)));
end