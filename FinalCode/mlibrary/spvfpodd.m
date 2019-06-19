function ddPS=spvfpodd(array,directions,I,L,IAZorEL,LAZorEL);
%...................................................
% ddPS=spvfpodd(array,directions,I,L,IAZorEL,LAZorEL);
% second derivative of Projection operator with 
% respect to the Azimuth/Elevation of the I-th/L-th sources 
% written by Dr A.Manikas
%...................................................

S=spv(array,directions);
invSS=inv(S'*S);
pinvS=invSS*S';
QS=fpoc(S);

[dSaz,dSel]=spvd(array,directions);

if IAZorEL=='az'; SI=dSaz;
   else SI=dSel;
end;

if LAZorEL=='az'; SL=dSaz;
   else SL=dSel;
end;

[dSazaz,dSelel,dSazel]=spvdd(array,directions); 
if IAZorEL==LAZorEL 
   if IAZorEL=='az'; SIL=dSazaz;
   else              SIL=dSelel;
   end;
else
  SIL=dSazel;
end;


M=QS*SL(:,I)*pinvS(I,:);
dPS=M+M';
M=zeros(size(SL));
M(:,I)=SL(:,I);
dPSS= -dPS*SI(:,L)*pinvS(L,:)+QS*SI(:,L)*invSS(L,:)*M'*QS-QS*SI(:,L)*pinvS(L,:)*SL(:,I)*pinvS(I,:);
  
if I==L 
   dPSS=QS*SIL(:,L)*pinvS(L,:)+dPSS;
end;

ddPS=dPSS+dPSS';
