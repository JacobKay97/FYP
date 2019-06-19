% Test program 
% Reference : 
clc;format compact
%load tur15350;
%load tursnaps;
%pusher=[25 7.5; 25 82.5; 25 97.5;25 172.5; 25 277.5; 25 352.5];
%pusher(:,2)=90-pusher(:,2);
%c=3*10^8; f=1535*10^4;
%array=toxyz(pusher)*2*f/c;
clear all; load cor24980; 
save temp SV NV Dist Angle FQ; clear all
load temp
array=pusher2([Dist,Angle],FQ);
ans = input('Type 1 to use your own M or type 2 to use M provided by dif-MDL criterion : ');
count=0; BestDirection=[];
ans2 = input('Type 1 to use i:i+NV-1 snaps or type 2 to use 1:i+NV-1 snaps');
clc
for i=1:NV:(length(SV)-NV+1);
  
  count=count+1  
  if      ans2==1, snaps=i:i+NV-1;
  else             snaps=1:i+NV-1;
  end

  L=length(SV(:,snaps));
  Rxx=SV(:,snaps)*SV(:,snaps)'/L; 

  if ans == 1, 
     M=2;
  else
     figure(1); M = detect2(Rxx,L);  
     fprintf('the number of sources is:'),M
  end

  Azarea=0:1:360; Elarea=0:2:90;
  
  figure(2),Z=music270(Rxx,array,M,Azarea,Elarea);
 
  Best=minnmatr(-Z,Azarea,Elarea,5);
  Bestdirections(:,count)=Best(:);
end
if     ans2==1,   save temp3_1
elseif ans2==2,   save temp3_2
end
%------------------------------------------------------------

