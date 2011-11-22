function d = LTE_UL_IDFT_Change(z, LTE_link_params)
len = length(z);
d = zeros(1,len);
M_SubC_p_PUSCH = LTE_link_params.N_assigned_SubC_p_Layer; 
li = 0 : len/M_SubC_p_PUSCH-1;
for l = li
    d(l*M_SubC_p_PUSCH +1 : (l+1)*M_SubC_p_PUSCH) = sqrt(M_SubC_p_PUSCH) * ifft(z(l*M_SubC_p_PUSCH +1 : (l+1)*M_SubC_p_PUSCH));
end