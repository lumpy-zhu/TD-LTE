% SCM channel model (extended)
% Version 1.0, May 31, 2005
%
% Channel model functions
%   scm               - 3GPP Spatial Channel Model (extended)
%   scmparset         - Model parameter configuration for SCM
%   linkparset        - Link parameter configuration for SCM
%   antparset         - Antenna parameter configuration for SCM
%   pathloss          - Pathloss models for 2GHz and 5GHz 
%
%   WINNER-specific functions
%   scenparset        - Set SCM parameters for WINNER scenarios
%
% Miscellaneous functions
%   cas               - Circular angle spread (3GPP TR 25.996)
%   ds                - RMS delay spread 
%   dipole            - Field pattern of half wavelength dipole
%
% Utility functions
%   interp_gain       - Antenna field pattern interpolation
%   interp_gain_c     - Antenna field pattern interpolation (requires GSL)
%   scm_core          - Channel coefficient computation for a geometric channel model
%   scm_mex_core      - SCM_CORE written in ANSI-C 
%   generate_bulk_par - Generation of SCM bulk parameters
%   

% $Revision: 1.0 $ $Date: May 20, 2005$
