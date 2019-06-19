function [Es,En] = eigspace(Rxx,M);
%..............................................
% [Es,En] = eigspace(Rxx,M);
% Es: signal subspace eigenvectors of Rxx
% En: noise subspace eigenvectors of Rxx
% M : number of signals
%..............................................

[eigvecs,eigvals] = eig(Rxx);   
[i,j] = sort(diag(eigvals));          
eigvecs = eigvecs(:,flipud(j));  % sort in descending order

Es = eigvecs(:,1:M);
En = eigvecs(:,M+1:length(Rxx(:,1)));
