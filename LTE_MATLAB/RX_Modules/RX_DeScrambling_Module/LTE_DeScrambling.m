function rx_descrambled_bits = LTE_DeScrambling(rx_data_llr, q, eNodeB, UE, LTE_common_params, LTE_link_params)
switch LTE_link_params.scrambling_type
    case 'no scrambling'
        rx_descrambled_bits = rx_data_llr;
    case 'scrambling'
        n_subframe = LTE_link_params.n_subfrm;
        n_RNTI = UE.n_RNTI;
        n_cellID = eNodeB.n_cellID;
        pn_seq = double(LTE_Gen_Gold_Sequence(length(rx_data_llr), n_RNTI, q, n_subframe, n_cellID));
        pn_seq(pn_seq==0) = -1;
        rx_descrambled_bits = -(rx_data_llr.*pn_seq);
    otherwise
        error('scrambling type is not supported!');
end