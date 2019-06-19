function [Mmdl,Maic,MDL,AIC] = detect(Rxx,L)

%*************************************************************************
% by Naushad Dowlut, 8 Dec 1993
% Reference : 	M. Wax and T. Kailath
%		"Detection of Signals by Information Theoretic Criteria"
%		IEEE Trans. ASSP, vol. ASSP-33, pp. 387-392, Apr. 1985              
%----------------------------------------------------------------------
% Estimates the number of sources using the AIC and MDL criteria
%	Mmdl, Maic - no. of sources as estimated by AIC and MDL
%	MDL, AIC   - vector of criteria values
%	Rxx        - practical data covariance matrix
%	L 	   - no. of snapshots
%*************************************************************************

N = size(Rxx,1); 		% no. of sensors

eigvals = sort(abs(eig(Rxx)));	% sorted in ascending order

cp = flipud(log(cumprod(eigvals)));
cs = flipud(log(cumsum(eigvals)));

M = [0:(N-1)]';		% M - parameter used for the estimation 
r = N - M;


AIC = zeros(N,1);
MDL = zeros(N,1);

AIC = -2*L*(cp + r.*(log(r) - cs)) + 2*M.*(2*N-M);
MDL = -L*(cp + r.*(log(r) - cs)) + (1/2)*log(L)*M.*(2*N-M);
AIC=1./AIC;MDL=1./MDL;
[Y,Maic] = max(AIC);
[Y,Mmdl] = max(MDL);

Maic = Maic-1;		% since M starts @ 0
Mmdl = Mmdl-1;


   subplot(211)
         bar([0:length(AIC)-1]',AIC),title('DETECTION CRITERIA');
         xlabel('Number of Sources '),
         ylabel('AIC'),
         grid;
    subplot(212)
         bar([0:length(MDL)-1]',MDL),
         xlabel('Number of Sources '),
         ylabel('MDL'),
         grid;
    subplot









