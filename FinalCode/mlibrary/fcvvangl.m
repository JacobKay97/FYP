function [theta,phi]=fCVVangle(W,E);
%
z=diag(W'*E)./(sqrt(diag(W'*W)).*sqrt(diag(E'*E)));
theta=fdegrees(acos(abs(z)));
phi=angle(z);
