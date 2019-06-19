function [esensors,egain,ephase]=calibr4(allRxx,pilots,FQ,nomloc,nomgain,nomphase);
%[esensors,egain,ephase]=calibr4([Rxx1,Rxx2,Rxx3],pilots,nomloc,nomgain,nomphase);
N=length(allRxx(:,1));
Rxx1=allRxx(:,1:N);Rxx2=allRxx(:,N+1:2*N);Rxx3=allRxx(:,2*N+1:3*N);
c=3*10^8;
gsensors=nomloc;   % locations in meters
gphase1=nomphase(:,1);
gphase2=nomphase(:,2);
gphase3=nomphase(:,3);
ggain1=nomgain(:,1);ggain2=nomgain(:,2);ggain3=nomgain(:,3);
k=fki(frad(pilots(:,1)),frad(pilots(:,2)))*diag(2*FQ/c); 
k1=k(:,1);
k2=k(:,2);
k3=k(:,3);

O1=diag(exp(j*gphase1-j*gsensors*k1));
E=O1'*Rxx1*O1;U1=diag(E(:,1))/ggain1(1);
%U1(1)=ggain1(1);

O2=diag(exp(j*gphase2-j*gsensors*k2));
E=O2'*Rxx2*O2;U2=diag(E(:,1))/ggain2(1);
%U2(1)=ggain2(1);

O3=diag(exp(j*gphase3-j*gsensors*k3));
E=O3'*Rxx3*O3;U3=diag(E(:,1))/ggain3(1);
%U3(1)=ggain3(1);

E=j*log(diag(inv(U2)*U1));e1=real(E);K1=k1-k2;
E=j*log(diag(inv(U3)*U2));e2=real(E);K2=k2-k3;

temp2=K1(1)*K2(2)-K2(1)*K1(2);
y=(1/temp2)*(K1(1)*e2-K2(1)*e1);x=(1/K1(1))*(e1-K1(2)*y);
esensors=gsensors+[x,y,zeros(N,1)];

egain(:,1)=abs(diag(U1));Gamma=diag(egain(:,1));
Alpha=diag(exp(-j*(esensors-gsensors)*k1));
ephase(:,1)=gphase1-real(j*(log(diag(inv(Gamma)*U1*inv(Alpha)))));

egain(:,2)=abs(diag(U2));Gamma=diag(egain(:,2));
Alpha=diag(exp(-j*(esensors-gsensors)*k2));
ephase(:,2)=gphase2-real(j*(log(diag(inv(Gamma)*U2*inv(Alpha)))));

egain(:,3)=abs(diag(U3));Gamma=diag(egain(:,3));
Alpha=diag(exp(-j*(esensors-gsensors)*k3));
ephase(:,3)=gphase3-real(j*(log(diag(inv(Gamma)*U3*inv(Alpha)))));