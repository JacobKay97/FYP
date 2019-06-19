function [pdfx,dx,PSD,H,Px,std2,Nx]=pdf(x,bin)

dx=zeros(bin,1);
pdfx=zeros(bin,1);

H=[];
Nx1=[];
[L,M]=size(x);
PSD=zeros(L,1);

for i=1:M;
  home;i

  [pdfx1,dx1]=hist(x(:,i),bin);
  pdfx1=pdfx1/L/(abs(dx1(1)-dx1(2)));
  PSD1=abs(fft(x(:,i))/L).^2;

  H1=-sum(pdfx1.*log2(pdfx1))*abs(dx1(1)-dx1(2));
 % Nx1=2^(2*H1)/(2*pi*exp(1));  
  pdfx=pdfx+pdfx1';
  PSD=PSD+PSD1;
  dx=dx+dx1';
  if isnan(H1)==0, H=[H;H1]; Nx=[Nx;Nx1];  end;

end;

pdfx=pdfx/M;
dx=dx/M; 
PSD=PSD/M;

H=mean(H)
Px=trace(x'*x)/(L*M)
DC=mean(x); std2=trace((x-repr(DC,L))'*(x-repr(DC,L)))/(L*M)
%Nx=mean(Nx)
Nx=2^(2*H)/(2*pi*exp(1))

figure(2); plot(dx,pdfx);
figure(3); semilogy(PSD);