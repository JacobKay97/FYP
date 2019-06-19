function Z=music(Rxx,SENSORS,M,AZarea,ELarea,mainlobe,ingain,inphase);
%.......................................................
% Z=music(Rxx,SENSORS,M,AZarea,ELarea,mainlobe,ingain,inphase);
% writen by Dr A.Manikas (IC)
% estimates the MuSIC spectrum
% ref.:
% N.B.: if f and c are given then  use SENSORS*2*f/c
%.......................................................
N=length(SENSORS(:,1));

if nargin<7; g=ones(N,length(AZarea)); else g=repc(ingain.*exp(j*inphase),length(AZarea));end;
if nargin<6
   mainlobe=[];
end;

[MEIG,D] = eig(Rxx);
[lamda,k]=sort(diag(D));
MEIG=MEIG(:,k);

EE = MEIG(:,1:N-M);
for I=1:N-M;
    EE(:,I)=EE(:,I)/sqrt(abs(EE(:,I)'*EE(:,I)));
end;

  y=0;
  for el=ELarea;
    y=y+1;
    home; el;
    SOURCES=[AZarea',el*ones(size(AZarea'))];
    S=g.*spv(SENSORS,SOURCES,mainlobe);

    Z(y,:)=-10*log10(real(diag(S'*EE*EE'*S)))';
  end;

