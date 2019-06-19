function r=pusher2(antipolar,FQ);

pusher=antipolar;
pusher(:,2)=90-pusher(:,2);
c=3*10^8;
r=toxyz(pusher);
if nargin==2 r=r*2*FQ/c;end;
