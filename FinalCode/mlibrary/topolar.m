function p=topolar(x);
p=[sqrt(x(:,1).^2+x(:,2).^2),fdegrees(atan2(x(:,2),x(:,1)))];