function [H_Frm H_FFT] = LTE_Gen_MIMO_Channel(LTE_common_params, LTE_link_params, LTE_channel_params)
%%% frame structure is DSUUDDSUUD, the last ofdm_symbol in special subframe is used for
%%% estimating channel for the following subframes(start at DL). So at the beginning, it
%%% generate a large channel, DSUUD-DSUUDDSUUD, subfrm1 to subfrm4 use the first special subframe,
%%% sfrm5 to sfrm9 use the second one, sfrm10 use the third one

N_Tx = LTE_link_params.MIMO_params.N_Tx;
N_Rx = LTE_link_params.MIMO_params.N_Rx;
N_BS = LTE_common_params.N_BS;
N_MS = LTE_common_params.N_MS;
N_OFDM = LTE_common_params.N_OFDM_p_subframe;
len = length(LTE_common_params.frm_str);
N_OFDM_all = len * 3/2 * N_OFDM;
N_SubC = LTE_link_params.N_assigned_SubC_p_Layer;

H_all = cell(N_BS, N_BS, N_MS);
H_Frm = cell(N_BS, N_BS, N_MS);
H_FFT = cell(N_BS, N_BS, N_MS);

sp = LTE_common_params.i_frm_sp;

switch LTE_channel_params.time_correlation
    case 'BlockFading'
        % generate ChanModel realization
        switch LTE_channel_params.channel_type
            case {'AWGN'}
                H_4x4 = [1,1,1,1;
                    1,-1,-1,1;
                    1,-1,1,-1;
                    1,1,-1,-1];
                H_link = H_4x4(1:N_Rx,1:N_Tx);
                LTE_link_params.channel.H = H_link;
                H_tmp(1,1,:,:) = H_link;
                LTE_link_params.channel.H_FFT = repmat(H_tmp,[N_SubC,N_OFDM_all,1,1]);
        end
    case 'FastFading'
        switch LTE_channel_params.channel_type
            %%%%%%%
            case {'TU', 'flat', 'scmVA','epa','eva','etu'}
                
                C = 299792458;
                BandWidth = LTE_common_params.BandWidth;
                f = LTE_channel_params.carrierFrequency;      % carrier frequency
                fft_size = N_SubC;
                v = LTE_channel_params.ueVelocity;  %speed at which we move
                df_Doppler = v*f/C/3.6; % 3.6 means change m/s to km/h
                num_samples = N_OFDM_all;
                R_Tx_correlation = sqrtm(gen_antenna_correlation(N_Tx,LTE_channel_params.antenna_correlation_type));
                PDP_type = LTE_channel_params.channel_type;
                switch PDP_type
                    case 'TU'
                        pdp = [0, 0.2, 0.6, 1.6, 2.4, 5; % delay (us)
                            -3, 0, -2, -6, -8, -10]; % power (dB)
                    case 'flat' % flat fading channel (for test only)
                        pdp = [0; 0];
                    case 'scmVA'
                        pdp = [0, 0.31, 0.71, 1.09, 1.73, 2.51; % delay (us)
                            0, -1, -9, -10, -15, -20]; % power (dB)
                    case 'epa' % from TS 36.104 (pp. 61)
                        pdp = [0, 0.03, 0.07, 0.09, 0.11, 0.19, 0.41; ...
                            0, -1, -2, -3, -8, -17.2, -20.8];
                    case 'eva' % from TS 36.104 (pp. 61)
                        pdp = [0, 0.03, 0.15, 0.31, 0.37, 0.71, 1.09, 1.73, 2.51; ...
                            0, -1.5, -1.4, -3.6, -0.6, -9.1, -7, -12, -16.9];
                    case 'etu' % from TS 36.104 (pp. 61)
                        pdp = [0, 0.05, 0.12, 0.2, 0.23, 0.5, 1.6, 2.3, 5; ...
                            -1, -1, -1, 0, 0, 0, -3, -5, -7];
                    otherwise
                        error('not supported channel model');
                end
                
                H_tmp_norm = zeros(fft_size, num_samples, N_Tx * N_Rx);
                for n_bs = 1:N_BS
                    for k_bs = 1:N_BS
                        for n_ms =1:N_MS
                            
                            for ant_idx = 1: N_Tx * N_Rx
                                h = zeros(fft_size, num_samples);
                                for tap = 1: size(pdp, 2)
                                    h(round(pdp(1, tap) * 1e-6 * BandWidth) + 1, :) =...
                                        (10 ^ (pdp(2, tap) / 10)) * Modified_Jakes(df_Doppler, fft_size/BandWidth, num_samples);
                                end
                                H_tmp = fft(h);
                                H_tmp_norm(:, :, ant_idx) = H_tmp / sqrt(mean(abs(H_tmp(:)) .^ 2));
                            end
                            %                             H = reshape(H_tmp_norm, [fft_size, num_samples, N_Rx, N_Tx]);
                            H = reshape(permute(H_tmp_norm, [3, 1, 2]), [N_Rx, N_Tx, fft_size*num_samples]);
                            H_tmp = zeros(N_Tx,fft_size*num_samples);
                           
                            for i_Rx = 1:N_Rx
                                H_tmp(:,:) = H(i_Rx,:,:);
                                H(i_Rx,:,:) = R_Tx_correlation * H_tmp(:,:);
                                for i_Tx = 1:N_Tx
                                    H(i_Rx,i_Tx,:) = H(i_Rx,i_Tx,:)/sqrt(mean(abs(H(i_Rx,i_Tx,:)) .^ 2));
                                end
                            end
                            H = reshape(H, [N_Rx, N_Tx, fft_size,num_samples]);
                            H_all{n_bs,k_bs,n_ms} = H;
                        end
                    end
                end
                %%%%%%%%%%%%%%
            case 'SCM'
                
                %%%%%%%%%%%%%%%%%%%%
                addpath ./Channel_Modules/SCM_Channel_Model/
                scmpar = scmparset;
                linkpar = linkparset;
                antpar = antparset;
                
                scmpar.NumTimeSamples = N_OFDM_all;
                scmpar.NumBsElements = LTE_link_params.MIMO_params.N_Tx;
                scmpar.NumMsElements = LTE_link_params.MIMO_params.N_Rx;
                for n_bs = 1:N_BS
                    for k_bs = 1:N_BS
                        for n_ms =1:N_MS
                            
                            [h tau] = scm(scmpar,linkpar,antpar);
                            % h has dimension of N_RX, N_TX, N_subc/2, N_OFDM
                            
                            BandWidth = LTE_common_params.BandWidth;
                            
                            
                            [N_AT_MS N_AT_BS num_pads N_OFDM_all] = size(h);
                            h_t = zeros(N_SubC,N_OFDM_all);
                            H = zeros(N_AT_MS,N_AT_BS,N_SubC,N_OFDM_all);
                            %                             b = 0;
                            for i = 1:N_AT_MS
                                for j = 1:N_AT_BS
                                    for k = 1:num_pads
                                        h_t(round(tau(k)*BandWidth)+1,:) = h_t(round(tau(k)*BandWidth)+1,:) + shiftdim(h(i,j,k,:),2);
                                    end
                                    H_FFT = fft(h_t);
                                    H_temp = H_FFT / sqrt(mean(abs(H_FFT(:)) .^ 2));
                                    %                                     H_1 = abs(H_temp);
                                    %                                     H_2 = H_1.*H_1;
                                    %                                     a = sum(H_2);
                                    %                                     b = b+sum(a);
                                    H(i,j,:,:) = H_temp;
                                end
                            end
                            %                             c = sqrt((N_AT_MS*N_AT_BS*N_SubC*N_OFDM)/b);
                            LTE_link_params.channel.H_FFT{n_bs,k_bs,n_ms} = H;
                        end
                    end
                end
                rmpath ./Channel_Modules/SCM_Channel_Model/
            case 'Rayleigh'
                for n_cell = 1:N_BS
                    for i = 1:N_BS
                        for j = 1:N_MS
                            temp = 1/sqrt(2)*(randn(N_Rx,N_Tx,N_SubC,N_OFDM_all)...
                                +1i*randn(N_Rx,N_Tx,N_SubC,N_OFDM_all));
                            LTE_link_params.channel.H_FFT{n_cell,i,j} = temp;
                        end
                    end
                end
            otherwise
                error('Channel type not supported for fast fading');
        end
    otherwise
        error('chanMod.filtering type not supported');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n_bs = 1:N_BS
    for k_bs = 1:N_BS
        for n_ms =1:N_MS
            H_tmp = H_all{n_bs, k_bs, n_ms};
            H_FFT{n_bs, k_bs, n_ms} = H_tmp(:,:,:,sp*N_OFDM+1 : (sp+1)*N_OFDM);
            H_Frm{n_bs, k_bs, n_ms} = H_tmp(:,:,:,len/2 *N_OFDM+1 : end);
        end
    end
end





