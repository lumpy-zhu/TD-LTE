clear all;
close all;

L = 62;             % length of the sequence
N_C = 1600;
n_RNTI = 5;         % RNTI value of UE
q = 1;              % code word index
n_cellID = 6;       % cell ID
n_subframe = 7;     % number of subframe
x_1 = zeros(1,31);  
x_1(1) = 1;
% c_init = n_RNTI*2^14 + q*2^13 + floor(n_subframe/2)*2^9 + n_cellID;
c_init = n_RNTI*2^14 + q*2^13 + (n_subframe - 1)*2^9 + n_cellID;
x_2 = de2bi(c_init,31);
for i = 1:(L+N_C)
    x_1(i+31) = mod(x_1(i+3)+x_1(i),2);
    x_2(i+31) = mod(x_2(i+3)+x_2(i+2)+x_2(i+1)+x_2(i),2);
    if i>N_C
        cc(i-N_C) = mod(x_1(i)+x_2(i),2);
    end
end
c = mod(x_1((1+N_C):(L+N_C))+x_2((1+N_C):(L+N_C)),2);
aa = LTE_common_gen_gold_sequence(L,n_cellID,n_RNTI,n_subframe,q);