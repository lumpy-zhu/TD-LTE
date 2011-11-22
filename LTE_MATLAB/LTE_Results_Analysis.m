function var = LTE_Results_Analysis(ii_MCS, nn, N_frames, result, var)
for frm = 1:N_frames
    for index = 1 : 4 % N_BS*N_MS
        tmp.dl_bler( nn,ii_MCS,frm,index ) =  result(nn,ii_MCS,frm).dl_bler(index);
        tmp.dl_ber( nn,ii_MCS,frm,index ) =  result(nn,ii_MCS,frm).dl_ber(index);
        tmp.dl_throughput( nn,ii_MCS,frm,index ) =  result(nn,ii_MCS,frm).dl_throughput(index);
        tmp.ul_bler( nn,ii_MCS,frm,index ) =  result(nn,ii_MCS,frm).ul_bler(index);
        tmp.ul_ber( nn,ii_MCS,frm,index ) =  result(nn,ii_MCS,frm).ul_ber(index);
        tmp.ul_throughput( nn,ii_MCS,frm,index ) =  result(nn,ii_MCS,frm).ul_throughput(index);
    end
end
var.dl_bler(nn,ii_MCS,:) = mean(tmp.dl_bler(nn,ii_MCS,:,:),3);
var.dl_ber(nn,ii_MCS,:) = mean(tmp.dl_ber(nn,ii_MCS,:,:),3);
var.dl_throughput(nn,ii_MCS,:) = mean(tmp.dl_throughput(nn,ii_MCS,:,:),3);
var.ul_bler(nn,ii_MCS,:) = mean(tmp.ul_bler(nn,ii_MCS,:,:),3);
var.ul_ber(nn,ii_MCS,:) = mean(tmp.ul_ber(nn,ii_MCS,:,:),3);
var.ul_throughput(nn,ii_MCS,:) = mean(tmp.ul_throughput(nn,ii_MCS,:,:),3);
save results.mat var;