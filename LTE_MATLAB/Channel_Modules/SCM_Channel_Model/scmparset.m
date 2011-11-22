function scmpar=scmparset(varargin)
%SCMPARSET Model parameter configuration for SCM
%   SCMPAR=SCMPARSET sets default parameters for the input struct SCMPAR 
%   (see SCM). 
%
%   SCMPARSET parameters [ {default} ]:
%
%   NumBsElements           - Number of BS array antenna elements [ {2} ]
%   NumMsElements           - Number of MS array antenna elements [ {2} ]
%   Scenario                - SCM scenario [ suburban_macro | urban_macro | {urban_micro} ]
%   SampleDensity           - number of time samples per half wavelength [ {2} ]
%   NumTimeSamples          - number of time samples [ {100} ]
%   UniformTimeSampling     - Use same time sampling grid for all links [ yes | {no} ] 
%   BsUrbanMacroAs          - BS angle spread for urban macro in degrees [ {eight} | fifteen ]
%   NumPaths                - number of paths [ {6} ]
%   NumSubPathsPerPath      - number of subpaths per path [ {20} ] (cannot be changed)
%   IntraClusterDsUsed      - non-zero delay spread for clusters [ yes | {no} ]
%   FixedPdpUsed            - nonrandom path delays and powers [ yes | {no}]
%   FixedAnglesUsed         - nonrandom AoD/AoAs [ yes | {no} ]
%   DriftDelaysAngles       - Use time-variant delays and angles [ yes | {no} ]
%   DriftShadowFading       - Use time-variant shadow fading [ yes | {no} ]
%   CenterFrequency         - carrier frequency in Herz [ {2e9} ]
%   ScmOptions              - SCM optional features [ {none} | polarized | los | urban_canyon ]
%   DelaySamplingInterval   - delay sampling grid [ {5e-9} ]
%   PathLossModelUsed       - usage of path loss model [ yes | {no} ]
%   ShadowingModelUsed      - usage of shadow fading model [ yes | {no} ]
%   PathLossModel           - path loss model function name [ {pathloss} ]
%   AlternativePathloss'    - defines if alternative or SCM pathloss is used [ yes | {no} ], table 3 of [2]
%   AnsiC_core              - use optimized computation [ yes | {no} ]
%   LookUpTable             - look up EXP(j*THETA) from a table [{0}]
%   RandomSeed              - sets random seed [ {[empty]} ]
%
%   Notes about parameters:
%   - The number of BS and MS elements is normally extracted from ANTPAR.
%     The values of NumBsElements and NumMsElements are used only if a single
%     scalar is given as the antenna field pattern in ANTPAR (see ANTPARSET).
%   - For successful Doppler analysis, one should select SampleDensity > 1.
%     The time sample interval is calculated from CenterFrequency and
%     MsVelocity (see LINKPARSET) according to wavelength/(2*MsVelocity*SampleDensity).
%     The calculated time sample interval for each link is included in the optional 
%     output argument of SCM. 
%   - If UniformTimeSampling is 'yes' all links will be sampled at
%     simultaneous time instants. In this case, the time sample interval is
%     the same for all links it is calculated by replacing MsVelocity with
%     MAX(MsVelocity), where the maximum is over all links. 
%   - Number of paths can be changed at will, but the SCM specification [1]
%     supports only six paths. The delays and mean AoD/AoAs are determined
%     according to [1], but the subpath AoD/AoAs are always taken from [1,
%     Table 5.2].
%   - Number of subpaths is fixed to 20. This is because the AoD/AoAs for
%     subpaths in SCM have fixed angle spread given in [1, Table 5.2].
%   - If parameter IntraClusterDsUsed='yes' each path will be split to
%     three midpaths in macro scenarios and four midpaths in micro
%     scenario. The delays of these paths are fixed with respect to the
%     path/cluster so that intra-cluster rms delay spread is about 10e-9
%     seconds. The powers of the midpaths are fixed to [10/20 6/20 4/20]
%     and [7/20 5/20 4/20 4/20] of the total power of the path. Switching
%     on this option increases the effective bandwidth of the model [2]. 
%   - If FixedPdpUsed='yes', the delays and powers of paths are taken from
%     a table. The delay and power values have been selected for each
%     scenario so that, with IntraClusterDsUsed='yes', the frequency
%     correlation of the model over up to 100 MHz offsets does not have
%     high peaks (<0.7) and that the rms delay spread is approximately
%     equal to those of the SCM scenarios [2]. 
%   - If FixedAnglesUsed='yes', the AoD/AoAs are taken from a table [2].
%     Random pairing of AoDs and AoAs is not used. Note that one must fix
%     array orientations by setting linkpar.ThetaBs=0 and linkpar.ThetaMs=0
%     to reproduce the angles given in Table 5 of [2]. 
%   - With DriftDelaysAngles='yes', the AoAs and path/midpath delays will
%     change according to the scatterer geometry and MS movement [2]. 
%   - With DriftShadowFading='yes', the shadow fading changes during a drop
%     according to lognormal distribution with 5, 50, 250 meter (50%) 
%     correlation distance for urban_micro, urban macro, and suburban macro,
%     respectively [2]. It is required that scmpar.ShadowingModelUsed='yes' 
%     for this feature to work.
%   - CenterFrequency affects path loss and time sampling interval.
%   - DelaySamplingInterval determines the sampling grid in delay domain.
%     All path delays are rounded to the nearest grid point. It can also 
%     be set to zero. 
%   - When PathLossModelUsed is 'no' the path losses are still computed for
%     each link but they are not multiplied into the channel matrices. If
%     ShadowingModelUsed is also 'no', each channel matrix element has unit
%     mean power (summed over delay domain). In other words,
%     MEAN(MEAN(ABS(SUM(H,3)).^2,4),5) is a matrix of (approximately) ones 
%     when isotropic unit-gain antennas are used. Exception: with
%     'polarized' option the mean power depends on the path XPD ratios.
%   - Path loss model is implemented in a separate function, whose name is
%     defined in PathLossModel. For syntax, see PATHLOSS. 
%   - The C-function must be compiled before usage. For more information 
%     of the ANSI-C core function, see SCM_MEX_CORE. 
%   - The LookUpTable parameter defines the number of points used in the
%     cosine look-up table; a power-of-2 should be given. The look-up table 
%     is used only in the ANSI-C optimized core function. Value 0 indicates
%     that look-up table is not used. Value -1 uses the default number of 
%     points, which is 2^14=16384. Since a large part of computation in SCM 
%     involves repeated evaluation of a complex exponential, the look-up 
%     table can speed up computation on certain platforms and C compilers.
%   - Even fixing the random seed may not result in fully repeatable
%     simulations due to differences in e.g. MATLAB versions. 
%
%   Ref. [1]: 3GPP TR 25.996 v6.1.0 (2003-09)
%        [2]: D. Baum et al, IEEE VTC'05 (spring)
%
%   See also SCM, LINKPARSET, ANTPARSET, SCENPARSET.

%   Authors: Jari Salo (HUT), Pekka Kyösti (EBIT), Daniela Laselva (EBIT), 
%   Giovanni Del Galdo (TUI), Marko Milojevic (TUI), Christian Schneider (TUI)
%   $Revision: 0.4 $  $Date: May 20, 2005$




if length(varargin)>0
    error('No such functionality yet. Try ''scmpar=scmparset'' instead.')
end

% Set the default values
scmpar=struct(  'NumBsElements',2,...                   
                'NumMsElements',2,...                   
                'Scenario','urban_micro',...
                'SampleDensity', 2,...                  % in samples/half-wavelength
                'NumTimeSamples',100,...                
                'UniformTimeSampling','no',...           
                'BsUrbanMacroAS','eight',...            % choices: 'eight' and 'fifteen'. 
                'NumPaths',6,...
                'NumSubPathsPerPath',20,...             % only value supported is 20.
                'IntraClusterDsUsed','no',...           % activate/disactivate midpaths
                'FixedPdpUsed','no',...                 % Use fixed delays and path powers
                'FixedAnglesUsed','no',...              % Use fixed AoD/AoAs
                'DriftDelaysAngles','no',...            % Use time-variant delays and angles
                'DriftShadowFading', 'no',...           % Use time-variant shadow fading
                'CenterFrequency',2e9,...               % in Herz
                'ScmOptions','none',...                 % 'none','polarized','los','urban_canyon'
                'DelaySamplingInterval',5e-9,...        
                'PathLossModelUsed','no',...            
                'ShadowingModelUsed','no',...           
                'PathLossModel','pathloss',...   
                'AlternativePathloss','no',...                  % 'yes'/'no', default is 'no'
                'AnsiC_core','no',...                   
                'LookUpTable',0,...                     % number of points in Ansi-C core look-up table for cosine, 0 if not used
                'RandomSeed',[]);                       % if empty, seed is not set.                                                                  



