% Test program 
% Reference : 
format compact
%load tur15350;
%load tursnaps;
radius = 25;
pusher=[25 7.5; 25 82.5; 25 97.5;25 172.5; 25 277.5; 25 352.5];
pusher(:,2)=90-pusher(:,2);
c=3*10^8; f=1535*10^4;
array=toxyz(pusher)*2*f/c;

ans=input('1 for 8192 snaps,\n 2 for specified snaps : ');

if       ans==1, Rxx=SV*SV'/8192;L=8192;

elseif   ans==2, snaps=input('Enter a:b:c : ')  
                 L=length(SV(:,snaps));
                 Rxx=SV(:,snaps)*SV(:,snaps)'/L;
end



ans2 = input('Type 1 to use M=1 or type 2 to use M provided by dif-MDL criterion : ');
if ans2 == 1, 
  M=1;
else
  figure(1); M = detect2(Rxx,L);  
  fprintf('the number of sources is:'),M
end
Azarea=0:1:360; Elarea=0:5:90;
Z=music270(Rxx,array,M,Azarea,Elarea);
plmusic(Z,Azarea,Elarea);
[maxZ,x]=maxmatr(Z);
BestDirection=[Elarea(x(:,1)),Azarea(x(:,2))]

if ans==1&ans2==1, save etur2r11, end
if ans==1&ans2==2, save etur2r12, end
if ans==2&ans2==1, save etur2r21, end
if ans==2&ans2==2, save etur2r22, end
%------------------------------------------------------------

