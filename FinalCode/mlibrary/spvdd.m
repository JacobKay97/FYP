function [dSazaz,dSelel,dSazel]=spvdd(array,direction,mainlobe);
%....................................................
% [dSazaz,dSelel,dSazel]=spvdd(array,direction,mainlobe);
% second derivatives of Source Position Vectors:
% if f and c are given then use array*2*f/c;
% written by Dr A.Manikas
%....................................................

if nargin<=2, mainlobe=[]; end;

SOURCES=frad(direction);
N=length(array(:,1));
M=length(SOURCES(:,1));

if nargin<=2 | mainlobe==[]
   U0=zeros(N,M);
else
   saz=frad(mainlobe(1));sel=frad(mainlobe(2));
   k0 = fki(saz,sel);
   U0=  repc(array*k0,M);
end;



%....................
KI = fki(SOURCES(:,1),SOURCES(:,2));
S = exp(-j*(array*KI - U0));

%....................
dKI=fdazki(SOURCES(:,1),SOURCES(:,2));
dUaz= array*dKI;
dSaz=-j*dUaz.*S ;
%....................
dKI=fdelki(SOURCES(:,1),SOURCES(:,2));
dUel= array*dKI;
dSel=-j*dUel.*S ;

%....................
dKI=fddazelki(SOURCES(:,1),SOURCES(:,2));
dU12=array*dKI;
dSazel=-j*dU12.*S - j*dUaz.*dSel;
%....................
dKI=fddelki(SOURCES(:,1),SOURCES(:,2));
dU12=array*dKI;
dSelel=-j*dU12.*S - j*dUel.*dSel;
%....................
dKI=fddazki(SOURCES(:,1),SOURCES(:,2));
dU12=array*dKI;
dSazaz=-j*dU12.*S -j*dUaz.*dSaz;

