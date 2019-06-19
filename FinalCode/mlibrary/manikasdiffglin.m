function [lm,CA,eCA,k,U_broad,Rk,incl]=manikasdiffglin(r,s);
%.........................................................................
%   [lm,CA,eCA,k,U_broad,Rk,incl]=diffglin(r);
%    r     = a column vector with the sensor positions of a linear array
%            this routine estimates
%    s     = 
%    lm    = manifold length;
%    k     = curvature vector;
%    U_s   = matrix with columns the coordinate vectors at broadside
%    Rk    = radii vector
%    C     = Cartan matrix
%    expmCs= expm^s.CA
%    incl  = inclination angle
%    written by Dr A. Manikas, 
%    Ref.: PhD thesis: J.Dacos 1991;
%          PhD thesis: R.Karimi 1993;
%........................................................................ 

  
N=length(r);   % Number of sensors N
lm=2*pi*norm(r); % length of the manifold
r=r/norm(r);   % normalised sensor locations

%Initial conditions
k=norm(r.^2);   % first curvature k1
b=zeros(2*N,2*N);
b(1:2*N-1,1)=ones(2*N-1,1);  % b(i,1)=1 for i>=1
b(2,2)=k(1)^2;   %b(2,2)=k1^2


%Radii veror Rk
Rk(1)=0;
Rk(2)=-1/k(1);

coordbroad(:,1)=-sqrt(-1)*r;
coordbroad(:,2)=-1/k(1)*r.^2;

poln=zeros(length(r),1);  % polynomial (see recursive Equ. - Equation 20 Ref.1)
i=2;

while k(length(k))>0.01
 i=i+1;
 for n=2:1:fix(i/2)+1;
    
    b(i,n)=b(i-1,n)+k(i-1)^2*b(i-2,n-1); 
    poln=poln+(-1)^(n-1)*b(i,n)*r.^(i+3-2*n);
 end;

 poln=poln+r.^(i+1);
 ns=norm(poln);
 k=[k,ns/prod(k)];
 poln=0;
 new1=zeros(length(r),1);
 for n=1:1:fix((i-1)/2)+1;
  new1=new1+(-1)^(n-1)*b(i-1,n)*r.^(i+2-2*n);
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

