% 
% function y_out= LTE_Sub_interleaver_tc( d_i, index, len, LTE_NULL)
% 
% this function performs Sub-block interleaver,created by YangWei, in 2008-4-7
% 
% input parameters:
% D_I is the input data need to be interleaverd
% INDEX represents the index of the input data, according to LTE protocol.there are three information bit streams, 
%       the interleaver mode of them are  not the same.so we need this argument to find out which stream the input data is;
% LEN is the length of the input data
% LTE_NULL is <null>
% 
% output:
% y_out:output data
% 
function y_out= LTE_Sub_Interleaving( d_i, index, len, LTE_NULL)

Permutation=[0,16,8,24,4,20,12,28,2,18,10,26,6,22,14,30,1,17,9,25,5,21,13,29,3,19,11,27,7,23,15,31];
Permutation=Permutation+1;

C_TC_sub=32;
R_TC_sub=floor(len/C_TC_sub)+1;
K_pi=C_TC_sub*R_TC_sub;
y_array=zeros(1,K_pi);
N_D=K_pi-len;

if N_D>0
    y_array(1:N_D)=LTE_NULL; %it is set to <NULL> according to the protocol, and is 2 in matlab program
end
y_array(N_D+1:K_pi)=d_i;

switch index
    case {1,2}
        y2=reshape(y_array,C_TC_sub,R_TC_sub);
        y_matrix=y2';
        y2=y_matrix(:,Permutation);
        y_out=reshape(y2,1,K_pi);
    case 3
        k=0:C_TC_sub*R_TC_sub-1;
        temp=floor(k/R_TC_sub)+1;
        % Pi_k=Permutation(temp)+C_TC_sub*mod(k,R_TC_sub)+1;
        Pi_k=Permutation(temp)+C_TC_sub*mod(k,R_TC_sub);
        Pi_k=mod(Pi_k,K_pi)+1;
        y_out=y_array(Pi_k);
    otherwise
        disp('error using sub_interleaving');
end%end of switch index


