function r=toxyz(pol);

r=[pol(:,1).*cos(frad(pol(:,2))),pol(:,1).*sin(frad(pol(:,2)))];
r=[r,zeros(size(r(:,1)))];
