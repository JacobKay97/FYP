clc; format compact;
%load tur15350;
ANS = input('Type: 1 to use detect, or 2 to use detect2, or 3 to use both : ');
M=[]; D=[];
L=16;total=8192; count=0;

for i=1:L:total-L+1;
home;count=count+1
figure(1)
    Rxx=SV(:,1:i+L-1)*SV(:,1:i+L-1)'/length(SV(:,1:i+L-1));
   
    if ANS==1,         [M1,M2,MDL,AIC]=detect(Rxx,length(SV(:,1:i+L-1)));
       elseif ANS==2,  [M1,M2,MDL,AIC]=detect2(Rxx,length(SV(:,1:i+L-1)));
       elseif ANS==3,  [M1,M2,MDL,AIC]=detect(Rxx,length(SV(:,1:i+L-1)));
                       [D1,D2,MDL,AIC]=detect2(Rxx,length(SV(:,1:i+L-1)));
                       D=[D,[count;D1;D2]];



    end;
    
M=[M,[count;M1;M2]];
end;
figure(2), bar(M(1,:),M(2,:));
if ANS==3,  figure(3), bar(D(1,:),D(2,:)); end;
 subplot(211)
         bar(M(1,:),M(2,:)),title('MDL DETECTION APPROACHES');
         xlabel('Slice Number'),
         ylabel('First detection approach '),
         grid;
    subplot(212)
         bar(D(1,:),D(2,:)),
         xlabel('Slice Number'),
         ylabel('Second detection approach'),
         grid;
    subplot
