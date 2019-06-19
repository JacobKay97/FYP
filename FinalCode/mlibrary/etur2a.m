% Test program 
% Reference : 
clc;format compact
%load tur15350;
load tursnaps;
pusher=[25 7.5; 25 82.5; 25 97.5;25 172.5; 25 277.5; 25 352.5];
pusher(:,2)=90-pusher(:,2);
c=3*10^8; f=1535*10^4;
array=toxyz(pusher)*2*f/c;

ans = input('Type 1 to use M=1 or type 2 to use M provided by dif-MDL criterion : ');
count=0; BestDirection=[];
ans2 = input('Type 1 to use i:i+16-1 snaps or type 2 to use 1:i+16-1 snaps');
for i=1:16:(8192-15);
  count=count+1
  if      ans2==1, snaps=i:i+16-1;
  else             snaps=1:i+16-1;
  end

  L=length(SV(:,snaps));
  Rxx=SV(:,snaps)*SV(:,snaps)'/L; 

  if ans == 1, 
     M=1;
  else
     figure(1); M = detect2(Rxx,L);  
     fprintf('the number of sources is:'),M
  end

  Azarea=0:0.5:360; Elarea=0:5:90;
  figure(2),Z=music90(Rxx,array,M,Azarea,Elarea);

  [maxZ,x]=maxmatr(Z);x
  BestDirection(count,:)=[Elarea(x(:,1)),Azarea(x(:,2))];
end
if     ans2==1,   save etur2ar1
elseif ans2==2,   save etur2ar2
end
%------------------------------------------------------------

