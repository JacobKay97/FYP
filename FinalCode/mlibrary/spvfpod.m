function dPS=spvfpod(array,directions,I,AZorEL);
%...................................................
% dPS=spvfpod(array,directions,I,AZorEL);
% first derivative of Projection operator with 
% respect to the Azimuth/Elevation of the I-th source 
% written by Dr A.Manikas
%...................................................
S=spv(array,directions);
pinvS=inv(S'*S)*S';
QS=fpoc(S);
[dSaz,dSel]=spvd(array,directions); 
if AZorEL=='az'; dS=dSaz;
   else dS=dSel;
end;

M=QS*dS(:,I)*pinvS(I,:);
dPS=M+M';