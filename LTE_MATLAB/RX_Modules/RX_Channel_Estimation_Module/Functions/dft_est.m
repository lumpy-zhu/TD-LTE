function H = dft_est(y, rs_seq, fft_size, start_idx, end_idx, layer_num, flag)

% DFT-based channel estimation
%
% mentor: Xiaolin Hou
% author: Wei Xi, xi@docomolabs-beijing.com.cn
% created on Jul. 22nd, 2009.

H = zeros(layer_num, length(y));
if(rs_seq(1) == 0)
    r = circshift(rs_seq,-1);
    y = circshift(y,-1);
else
    r = rs_seq;
end
win_len = 1.5*length(r);
win = blackman(win_len);

h_win = zeros(fft_size, 1);
h_win(1: length(y)) = y .* conj(r) .* win(center_index(length(win), length(y))) * flag;

cir = ifft(h_win);

% determine the location of each CIR.
cir_loc = [0: -1: 1-layer_num] / layer_num * fft_size/flag;

cir_range = mod([start_idx: end_idx], fft_size) + 1;

for layer_idx = 1: layer_num
	cir_tmp = zeros(size(cir));
	cir_win = mod([start_idx: end_idx] + cir_loc(layer_idx), fft_size) + 1;
	cir_tmp(cir_range) = cir(cir_win);
	H_tmp = fft(cir_tmp);
    H(layer_idx,:) = H_tmp([1: length(y)]) ./ win(center_index(length(win), length(y)));
end

if(rs_seq(1) == 0)
    H = circshift(H,[0,1]);
end

return;