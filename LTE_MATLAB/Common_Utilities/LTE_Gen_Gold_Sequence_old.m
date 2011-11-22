function seq_gold = LTE_Gen_Gold_Sequence_old(len_seq, n_RNTI, q, n_subframe, n_cellID)
% gold sequence generator for scrambling
% input:
%   len_seq:    length of required sequence
%   n_RNTI:     UE related ID, see 36.213 Section 7.1 for details
%   q:          codeword index
%   n_subframe: subframe index
%   n_cellID:   cell ID
%   N_C:        output offset
% ouput:
%   seq_gold:   gold sequence
% Created by Chongning Na Dec. 17, 2010

N_C = 1600;
x_1 = zeros(1,31);  
x_1(1) = 1;
c_init = n_RNTI*2^14 + q*2^13 + floor(n_subframe/2)*2^9 + n_cellID;
x_2 = de2bi(c_init,31);
for i = 1:(len_seq+N_C)
    x_1(i+31) = mod(x_1(i+3)+x_1(i),2);
    x_2(i+31) = mod(x_2(i+3)+x_2(i+2)+x_2(i+1)+x_2(i),2);
end
seq_gold = mod(x_1((1+N_C):(len_seq+N_C))+x_2((1+N_C):(len_seq+N_C)),2);