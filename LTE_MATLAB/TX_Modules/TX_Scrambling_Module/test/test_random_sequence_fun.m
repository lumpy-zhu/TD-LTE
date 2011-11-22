clear all;
close all;

addpath ../../../Common_Utilities/

L = 62;             % length of the sequence
N_C = 1600;
n_RNTI = 5;         % RNTI value of UE
q = 1;              % code word index
n_cellID = 6;       % cell ID
n_subframe = 7;     % number of subframe

cc = LTE_Gen_Gold_Sequence(L, n_RNTI, q, n_subframe, n_cellID, N_C);
aa = LTE_common_gen_gold_sequence(L,n_cellID,n_RNTI,n_subframe,q);