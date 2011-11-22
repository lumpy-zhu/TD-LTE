clear all
close all
clc

addpath ./SCME-2006-08-30/
scmpar = scmparset;
linkpar = linkparset;
antpar = antparset;

scmpar.NumBsElements = 4;
scmpar.NumMsElements = 2;

[h tau] = scm(scmpar,linkpar,antpar);
N_AT_BS = scmpar.NumBsElements;
N_AT_MS = scmpar.NumMsElements;
N_D = size(h,3);
N_Sample = size(h,4);

f_c = scmpar.CenterFrequency;
BandWidth = 20e6;
N_SC = 100;
f_SC = ((1:N_SC) - 0.5 - N_SC/2)*BandWidth/N_SC + f_c;

N_BS = 2;
K_MS = 2;
L = N_SC*N_Sample;
H_IC_all = zeros(N_AT_MS,N_AT_BS,N_BS,N_BS,K_MS,L);

for n_BS = 1:N_BS
    for m_BS = 1:N_BS
        for k_MS = 1:K_MS
            [h tau] = scm(scmpar,linkpar,antpar);
            for i = 1:N_AT_MS
                for j = 1:N_AT_BS
                    for k = 1:N_Sample
                        H(i,j,:,k) = exp(2*pi*1i*f_SC'*tau)*squeeze(h(i,j,:,k));
                    end
                    H_IC_all(i,j,n_BS,m_BS,k_MS,:) = reshape(H(i,j,:,:),[10000 1]);
                end
            end
            
        end
    end
end

save SCM_MIMO_IC_Channel.mat H_IC_all
