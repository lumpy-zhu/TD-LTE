function interleaved_bits = LTE_Interleaving(input_bits, interleaver_mapping, type)

switch type
    case 0  % inverse mapping
        interleaved_bits(interleaver_mapping) = input_bits;
    case 1  % mapping
        interleaved_bits = input_bits(interleaver_mapping);
end
    