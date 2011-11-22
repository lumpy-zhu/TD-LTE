function tx_scrambled_bits = LTE_Scrambling(tx_coded_bits, q, eNodeB, UE, LTE_common_params, LTE_link_params)
switch LTE_link_params.scrambling_type
    case 'no scrambling'
        tx_scrambled_bits = tx_coded_bits;
    case 'scrambling'
        n_subframe = LTE_link_params.n_subfrm;
        n_RNTI = UE.n_RNTI;
        n_cellID = eNodeB.n_cellID;
        pn_seq = LTE_Gen_Gold_Sequence(length(tx_coded_bits), n_RNTI, q, n_subframe, n_cellID);
        tx_scrambled_bits = mod(tx_coded_bits + pn_seq, 2);
    otherwise
        error('scrambling type is not supported!');
end