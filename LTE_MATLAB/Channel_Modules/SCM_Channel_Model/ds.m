function [sigma_DS, excess_delay]=ds(tau,P)
%DS RMS delay spread 
%   SIGMA_DS=DS(TAU,P) returns the rms delay spread SIGMA_DS. TAU are the
%   delays of paths and P are the powers of the corresponding paths. If P
%   is a matrix, SIGMA_DS is computed for each column; in this case TAU can
%   be either a matrix with SIZE(TAU)=SIZE(P) or a column vector with the
%   same number of rows as P. If TAU is a column vector the same delays are
%   used for each column of P.
%   
%   [SIGMA_DS, ED]=DS(TAU,P) returns also the excess delay in ED.
% 
%   Note that if P is an impulse response, SIGMA_DS is its sample rms delay
%   spread. 

%   Author: Jari Salo (HUT)
%   $Revision: 0.2 $  $Date: July 5, 2006$


if (ndims(tau) > 2 || ndims(P) > 2)
    error('Input arguments must be vectors or matrices!')
end


% if P is a vector
if ( min(size(P))==1 )
    P=P(:);     % make it column vector
end

if (min(size(tau))==1)  % if tau is a vector
    tau=tau(:);
    if length(tau) ~= size(P,1)
        error('Number of delays is not equal to number of powers!')
    end
    tau=repmat(tau,1,size(P,2))-min(tau);
else    % tau is a matrix
    if any( size(P)-size(tau) )
        error('Input argument size mismatch!')
    end
    tau=tau-repmat(min(tau),size(tau,1),1);
end


Dvec=sum(tau.*P)./(sum(P)+realmin);     % + realmin to avoid division by zero
D=repmat(Dvec,size(tau,1),1);

% compute std of delay spread
sigma_DS=sqrt( sum((tau-D).^2.*P)./(sum(P)+realmin ));


if (nargout>1)
    excess_delay=max(tau);
end





