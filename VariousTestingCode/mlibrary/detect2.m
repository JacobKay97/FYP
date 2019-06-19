function [Mmdl,Maic,MDL,AIC] = detect2(Rxx,L)

%*************************************************************************
% by Naushad Dowlut and A.Manikas, 31 March 1994
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
MDL = -L*(cp + r.*(log(r) - cs))   + (1/2)*log(L)*M.*(2*N-M);
for i=1:N-1;
   AIC(i)=10*log10(AIC(i))-10*log10(AIC(i+1));
   MDL(i)=10*log10(MDL(i))-10*log10(MDL(i+1));
end;
AIC(N)=[];MDL(N)=[];
[Y,Maic] = max(AIC); 
[Y,Mmdl] = max(MDL); 

   subplot(211)
         bar([1:length(AIC)]',AIC),title('DETECTION CRITERIA');
         xlabel('Number of Sources '),
         ylabel('AIC'),
         grid;
    subplot(212)
         bar([1:length(MDL)]',MDL),
         xlabel('Number of Sources '),
         ylabel('MDL'),
         grid;
    subplot









