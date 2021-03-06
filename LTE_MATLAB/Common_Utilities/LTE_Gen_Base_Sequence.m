function data = LTE_Gen_Base_Sequence(N_cell_ID, ns, N_RB, seq_len)
deta_ss = 0;
group_hopping_enabled = 1;
sequence_hopping_enabled = 1;
c_init = floor(N_cell_ID/30);
c = gen_length31_gold_sequence(8*ns + 8, c_init);

if group_hopping_enabled
    temp = 0;
    for i =0:7
        temp = temp + c(8*ns+i+1) * 2^i;
    end
    f_gh(ns+1) = mod(temp,30);
else
    f_gh(ns+1) = 0;
end
f_ss_pucch = mod(N_cell_ID, 30);
f_ss_pusch = mod(f_ss_pucch + deta_ss, 30);
u = mod(f_gh(ns+1) + f_ss_pusch, 30);
if(N_RB < 6)
    v = 0;
else
    if(~group_hopping_enabled && sequence_hopping_enabled)
        c_init = floor(N_cell_ID/30) * 2^5 + f_ss_pusch;
        c = gen_length31_gold_sequence(ns+1, c_init);
        v = c(ns+1);
    else
        v = 0;
    end
end

%%%%%%%%%
switch N_RB
    case 1 % CG-CASAC sequence in Tab. 5.5.1.2-1
        phi = [-1     1     3    -3     3     3     1     1     3     1    -3     3
            1     1     3     3     3    -1     1    -3    -3     1    -3     3
            1     1    -3    -3    -3    -1    -3    -3     1    -3     1    -1
            -1     1     1     1     1    -1    -3    -3     1    -3     3    -1
            -1     3     1    -1     1    -1    -3    -1     1    -1     1     3
            1    -3     3    -1    -1     1     1    -1    -1     3    -3     1
            -1     3    -3    -3    -3     3     1    -1     3     3    -3     1
            -3    -1    -1    -1     1    -3     3    -1     1    -3     3     1
            1    -3     3     1    -1    -1    -1     1     1     3    -1     1
            1    -3    -1     3     3    -1    -3     1     1     1     1     1
            -1     3    -1     1     1    -3    -3    -1    -3    -3     3    -1
            3     1    -1    -1     3     3    -3     1     3     1     3     3
            1    -3     1     1    -3     1     1     1    -3    -3    -3     1
            3     3    -3     3    -3     1     1     3    -1    -3     3     3
            -3     1    -1    -3    -1     3     1     3     3     3    -1     1
            3    -1     1    -3    -1    -1     1     1     3     1    -1    -3
            1     3     1    -1     1     3     3     3    -1    -1     3    -1
            -3     1     1     3    -3     3    -3    -3     3     1     3    -1
            -3     3     1     1    -3     1    -3    -3    -1    -1     1    -3
            -1     3     1     3     1    -1    -1     3    -3    -1    -3    -1
            -1    -3     1     1     1     1     3     1    -1     1    -3    -1
            -1     3    -1     1    -3    -3    -3    -3    -3     1    -1    -3
            1     1    -3    -3    -3    -3    -1     3    -3     1    -3     3
            1     1    -1    -3    -1    -3     1    -1     1     3    -1     1
            1     1     3     1     3     3    -1     1    -1    -3    -3     1
            1    -3     3     3     1     3     3     1    -3    -1    -1     3
            1     3    -3    -3     3    -3     1    -1    -1     3    -1    -3
            -3    -1    -3    -1    -3     3     1    -1     1     3    -3    -3
            -1     3    -3     3    -1     3     3    -3     3     3    -1    -1
            3    -3    -3    -1    -1    -3    -1     3    -3     3     1    -1];
        data = exp(1j * phi(u + 1, :) * pi / 4);
    case 2 % CG-CASAC sequence in Tab. 5.5.1.2.-2
        phi = [-1  	 3  	 1  	 -3  	 3  	 -1  	 1  	 3  	 -3  	 3  	 1  	 3  	 -3  	 3  	 1  	 1  	 -1  	 1  	 3  	 -3  	 3  	 -3  	 -1  	 -3
            -3  	 3  	 -3  	 -3  	 -3  	 1  	 -3  	 -3  	 3  	 -1  	 1  	 1  	 1  	 3  	 1  	 -1  	 3  	 -3  	 -3  	 1  	 3  	 1  	 1  	 -3
            3  	 -1  	 3  	 3  	 1  	 1  	 -3  	 3  	 3  	 3  	 3  	 1  	 -1  	 3  	 -1  	 1  	 1  	 -1  	 -3  	 -1  	 -1  	 1  	 3  	 3
            -1  	 -3  	 1  	 1  	 3  	 -3  	 1  	 1  	 -3  	 -1  	 -1  	 1  	 3  	 1  	 3  	 1  	 -1  	 3  	 1  	 1  	 -3  	 -1  	 -3  	 -1
            -1  	 -1  	 -1  	 -3  	 -3  	 -1  	 1  	 1  	 3  	 3  	 -1  	 3  	 -1  	 1  	 -1  	 -3  	 1  	 -1  	 -3  	 -3  	 1  	 -3  	 -1  	 -1
            -3  	 1  	 1  	 3  	 -1  	 1  	 3  	 1  	 -3  	 1  	 -3  	 1  	 1  	 -1  	 -1  	 3  	 -1  	 -3  	 3  	 -3  	 -3  	 -3  	 1  	 1
            1  	 1  	 -1  	 -1  	 3  	 -3  	 -3  	 3  	 -3  	 1  	 -1  	 -1  	 1  	 -1  	 1  	 1  	 -1  	 -3  	 -1  	 1  	 -1  	 3  	 -1  	 -3
            -3  	 3  	 3  	 -1  	 -1  	 -3  	 -1  	 3  	 1  	 3  	 1  	 3  	 1  	 1  	 -1  	 3  	 1  	 -1  	 1  	 3  	 -3  	 -1  	 -1  	 1
            -3  	 1  	 3  	 -3  	 1  	 -1  	 -3  	 3  	 -3  	 3  	 -1  	 -1  	 -1  	 -1  	 1  	 -3  	 -3  	 -3  	 1  	 -3  	 -3  	 -3  	 1  	 -3
            1  	 1  	 -3  	 3  	 3  	 -1  	 -3  	 -1  	 3  	 -3  	 3  	 3  	 3  	 -1  	 1  	 1  	 -3  	 1  	 -1  	 1  	 1  	 -3  	 1  	 1
            -1  	 1  	 -3  	 -3  	 3  	 -1  	 3  	 -1  	 -1  	 -3  	 -3  	 -3  	 -1  	 -3  	 -3  	 1  	 -1  	 1  	 3  	 3  	 -1  	 1  	 -1  	 3
            1  	 3  	 3  	 -3  	 -3  	 1  	 3  	 1  	 -1  	 -3  	 -3  	 -3  	 3  	 3  	 -3  	 3  	 3  	 -1  	 -3  	 3  	 -1  	 1  	 -3  	 1
            1  	 3  	 3  	 1  	 1  	 1  	 -1  	 -1  	 1  	 -3  	 3  	 -1  	 1  	 1  	 -3  	 3  	 3  	 -1  	 -3  	 3  	 -3  	 -1  	 -3  	 -1
            3  	 -1  	 -1  	 -1  	 -1  	 -3  	 -1  	 3  	 3  	 1  	 -1  	 1  	 3  	 3  	 3  	 -1  	 1  	 1  	 -3  	 1  	 3  	 -1  	 -3  	 3
            -3  	 -3  	 3  	 1  	 3  	 1  	 -3  	 3  	 1  	 3  	 1  	 1  	 3  	 3  	 -1  	 -1  	 -3  	 1  	 -3  	 -1  	 3  	 1  	 1  	 3
            -1  	 -1  	 1  	 -3  	 1  	 3  	 -3  	 1  	 -1  	 -3  	 -1  	 3  	 1  	 3  	 1  	 -1  	 -3  	 -3  	 -1  	 -1  	 -3  	 -3  	 -3  	 -1
            -1  	 -3  	 3  	 -1  	 -1  	 -1  	 -1  	 1  	 1  	 -3  	 3  	 1  	 3  	 3  	 1  	 -1  	 1  	 -3  	 1  	 -3  	 1  	 1  	 -3  	 -1
            1  	 3  	 -1  	 3  	 3  	 -1  	 -3  	 1  	 -1  	 -3  	 3  	 3  	 3  	 -1  	 1  	 1  	 3  	 -1  	 -3  	 -1  	 3  	 -1  	 -1  	 -1
            1  	 1  	 1  	 1  	 1  	 -1  	 3  	 -1  	 -3  	 1  	 1  	 3  	 -3  	 1  	 -3  	 -1  	 1  	 1  	 -3  	 -3  	 3  	 1  	 1  	 -3
            1  	 3  	 3  	 1  	 -1  	 -3  	 3  	 -1  	 3  	 3  	 3  	 -3  	 1  	 -1  	 1  	 -1  	 -3  	 -1  	 1  	 3  	 -1  	 3  	 -3  	 -3
            -1  	 -3  	 3  	 -3  	 -3  	 -3  	 -1  	 -1  	 -3  	 -1  	 -3  	 3  	 1  	 3  	 -3  	 -1  	 3  	 -1  	 1  	 -1  	 3  	 -3  	 1  	 -1
            -3  	 -3  	 1  	 1  	 -1  	 1  	 -1  	 1  	 -1  	 3  	 1  	 -3  	 -1  	 1  	 -1  	 1  	 -1  	 -1  	 3  	 3  	 -3  	 -1  	 1  	 -3
            -3  	 -1  	 -3  	 3  	 1  	 -1  	 -3  	 -1  	 -3  	 -3  	 3  	 -3  	 3  	 -3  	 -1  	 1  	 3  	 1  	 -3  	 1  	 3  	 3  	 -1  	 -3
            -1  	 -1  	 -1  	 -1  	 3  	 3  	 3  	 1  	 3  	 3  	 -3  	 1  	 3  	 -1  	 3  	 -1  	 3  	 3  	 -3  	 3  	 1  	 -1  	 3  	 3
            1  	 -1  	 3  	 3  	 -1  	 -3  	 3  	 -3  	 -1  	 -1  	 3  	 -1  	 3  	 -1  	 -1  	 1  	 1  	 1  	 1  	 -1  	 -1  	 -3  	 -1  	 3
            1  	 -1  	 1  	 -1  	 3  	 -1  	 3  	 1  	 1  	 -1  	 -1  	 -3  	 1  	 1  	 -3  	 1  	 3  	 -3  	 1  	 1  	 -3  	 -3  	 -1  	 -1
            -3  	 -1  	 1  	 3  	 1  	 1  	 -3  	 -1  	 -1  	 -3  	 3  	 -3  	 3  	 1  	 -3  	 3  	 -3  	 1  	 -1  	 1  	 -3  	 1  	 1  	 1
            -1  	 -3  	 3  	 3  	 1  	 1  	 3  	 -1  	 -3  	 -1  	 -1  	 -1  	 3  	 1  	 -3  	 -3  	 -1  	 3  	 -3  	 -1  	 -3  	 -1  	 -3  	 -1
            -1  	 -3  	 -1  	 -1  	 1  	 -3  	 -1  	 -1  	 1  	 -1  	 -3  	 1  	 1  	 -3  	 1  	 -3  	 -3  	 3  	 1  	 1  	 -1  	 3  	 -1  	 -1
            1  	 1  	 -1  	 -1  	 -3  	 -1  	 3  	 -1  	 3  	 -1  	 1  	 3  	 1  	 -1  	 3  	 1  	 3  	 -3  	 -3  	 1  	 -1  	 -1  	 1  	 3];
        data = exp(1j * phi(u + 1, :) * pi / 4);
    otherwise
        prime_seq = primes(seq_len);
        zc_seq_len = prime_seq(end);
        q_avr = zc_seq_len * (u + 1) / 31;
        q = floor(q_avr + 1/2) + v * ((-1) ^ floor(2 * q_avr));
        idx_seq_m = 0: zc_seq_len - 1;
        x_q = exp(-1j * pi * q * idx_seq_m .* (idx_seq_m + 1) / zc_seq_len);
        idx_seq_n = 0: seq_len - 1;
        data = x_q(mod(idx_seq_n, zc_seq_len) + 1);
end







