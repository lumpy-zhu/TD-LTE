function seq_matrix = get_seq(n_bs, n_ms)
N = n_ms * n_bs;
seq_matrix = zeros(N,N);
for i  = 1:n_bs
    for j = 1:n_ms
        k = (i-1)*n_ms+j;
        for m = 0:n_bs -1;
            x = mod(n_bs+2-i+m,n_bs);
            if x==0
                x = n_bs;
            end
            for n = 0:n_ms -1;
                y = mod(n_ms+2-j+n,n_ms);
                if y==0
                    y = n_ms;
                end
                w = (x-1)*n_ms+y;
                seq_matrix(k,w) = m*n_ms+n+1;
            end
        end
       
    end
end
