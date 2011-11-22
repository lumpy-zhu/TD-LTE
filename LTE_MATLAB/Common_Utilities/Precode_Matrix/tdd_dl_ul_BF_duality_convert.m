function [G_out P_out] = tdd_dl_ul_BF_duality_convert(G_in, P_in)
% this function converts the uplink and downlink TX and RX beamforming
% matrices using TDD system uplink & downlink duality property
% G_UL = P_DL';
% P_UL = G_DL';
% created by Chongning Na, 2011 May 19
% Last modified by Chongning Na, 2011 May 19
sPG = size(P_in);
P = P_in(:);
G = G_in(:);
nPG = numel(P_in);
P_out = cell(nPG,1);
G_out = cell(nPG,1);
for i = 1:nPG
    dimG = ndims(G{i});
    P_out{i} = conj(permute(G{i},[2 1 3:dimG]));
    dimP = ndims(P{i});
    G_out{i} = conj(permute(P{i},[2 1 3:dimP]));
end
P_out = reshape(P_out,sPG);
G_out = reshape(G_out,sPG);