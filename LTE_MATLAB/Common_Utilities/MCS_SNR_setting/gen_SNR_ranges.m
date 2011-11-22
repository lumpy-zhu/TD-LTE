clear all
close all
clc

load simu_range.mat
for i = 1:15
    MCS_SNR_range{i} = round(v_range{i}/0.1)*0.1;
end
save MCS_SNR_range.mat MCS_SNR_range; 