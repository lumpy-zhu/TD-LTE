function H_out = exchange(H_in, seq)
len = length(seq);
H_out = zeros(size(H_in));
for i = 1:len
    H_out(i,:) = H_in(seq(i),:);
end