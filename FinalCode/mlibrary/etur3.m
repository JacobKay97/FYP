clc, format compact
% Test program 
% Reference : 
format compact
%load tur15350;
% or load tursnaps;

%pusher=[25 7.5; 25 82.5; 25 97.5;25 172.5; 25 277.5; 25 352.5];
%pusher(:,2)=90-pusher(:,2);
%c=3*10^8; f=1535*10^4;
%array=toxyz(pusher)*2*f/c;
save temp SV NV Dist Angle FQ
clear all
load temp

array=pusher2([Dist, Angle],FQ);


count=0; eigenvalues=[];
ans2 = input('Type 1 to use i:i+NV-1 snaps or type 2 to use 1:i+NV-1 snaps');
for i=1:NV:(length(SV)-NV+1);
  home
  count=count+1
  if      ans2==1, snaps=i:i+16-1; M=1;
  else             snaps=1:i+16-1; figure(1); M = detect2(Rxx,L);  
                   fprintf('the number of sources is:'),M
  end

  L=length(SV(:,snaps));
  Rxx=SV(:,snaps)*SV(:,snaps)'/L; 
  D=eig(Rxx)
  eigenvalues=[eigenvalues,[M;sort(D)]];
 
end
if     ans2==1,   save temp4_1
elseif ans2==2,   save temp4_2
end
%------------------------------------------------------------


                       




    


 
