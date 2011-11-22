function z = LTE_UL_DFT_Change(d, LTE_link_params)
len = length(d);
z = zeros(1,len);
M_SubC_p_PUSCH = LTE_link_params.N_assigned_SubC_p_Layer; 
li = 0 : len/M_SubC_p_PUSCH-1;
for l = li
    z(l*M_SubC_p_PUSCH +1 : (l+1)*M_SubC_p_PUSCH) = 1/sqrt(M_SubC_p_PUSCH)*fft(d(l*M_SubC_p_PUSCH +1 : (l+1)*M_SubC_p_PUSCH));
end