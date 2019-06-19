function [lm,CA,eCA,k,coordbroad,Rk,incl]=diffglin(r);
%.........................................................................
%   [lm,CA,eCA,k,coordbroad,Rk,incl]=diffglin(r);
%    r=a row vector with the sensor positions of a linear array
%    this routine estimates
%       Lm=manifold length;
%       k=curvature vector;
%       coordbroad=matrix with columns the coordinate vectors at broadside
%       Rk=radii vector
%       CA=Cartan matrix
%       eCA=e^CA
%       incl=inclination angle
%    written by J. Dacos and Dr A. Manikas
%    Ref.: PhD thesis: J.Dacos 1991;
%          PhD thesis: R.Karimi 1993;
%........................................................................ 

r=r';  
n=length(r);
C=norm(r);
r=r/C;
k=norm(r.^2);
b=zeros(2*n,2*n);
for t=1:1:2*n-1;
b(t,1)=1;
end;
b(2,2)=k(1)^2;
new=norm(r.^3-k^2*r)/k(1);
k=[k,new];
b(3,2)=k(1)^2+k(2)^2;

K(1)=0;K(2)=-1/k(1);
new=zeros(1,length(r));
coordbroad(:,1)=-sqrt(-1)*r';
coordbroad(:,2)=-1/k(1)*r'.^2;


i=2;

while k(length(k))>0.01
 i=i+1;
 for n=2:1:fix(i/2)+1;
  b(i,n)=b(i-1,n)+k(i-1)^2*b(i-2,n-1);
  new=new+(-1)^(n-1)*b(i,n)*r.^(i+3-2*n);
 end;
 keyboard

 new=new+r.^(i+1);
 ns=norm(new);
 k=[k,ns/prod(k)];
 new=0;
 new1=zeros(length(r),1);
 for n=1:1:fix((i-1)/2)+1;
  new1=new1+(-1)^(n-1)*b(i-1,n)*r'.^(i+2-2*n);
  coordbroad(:,i)=new1*(-sqrt(-1))^i/prod(k(1:length(k)-1));
 end;
end;

if prod(r)==0;
  d=i+1;
  else
  d=i;
end;

if prod(r)==0;
 coordbroad(:,d)=zeros(length(r),1);
 coordbroad(find(abs(r)<0.0000001),d)=1;
end;

for i=3:1:d;
 if rem(i,2)==1;
    K(i)=0;
 else
    K(i)=K(i-2)*k(i-2)/k(i-1);
 end;
end;

if prod(r)==0;
 K(d)=1;
end;  

CA=zeros(d,d);
for i=1:1:d-1;
 CA(i,i+1)=k(i);
end;
for i=2:1:d;
 CA(i,i-1)=-k(i-1);
end;
eCA=2.7182^CA;

Rk=K;

incl=180/pi*acos(norm(K)/sqrt(length(r)));

lm=C*2*pi;