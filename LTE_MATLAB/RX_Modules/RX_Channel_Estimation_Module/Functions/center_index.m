function index = center_index(len_total, len)


over_len = len_total - len;
index = [1: len] + floor(over_len / 2);

return;