function [Ut,Up,ds,curvature1,inclination] = diffg1(array,direction);
%........................................................................
%[Ut,Up,ds,curvature1,inclination]=diffg1(array,direction);
% Estimates the firts two coordinate vectors U=[u1,u2],
%           the rate of change of arc length,
%           the first curvature k1 and k1inc
%           the inclination angle
% at one direction=[Azimuth,Elevation] for both theta & phi manifold-lines 
% of a general array.
% written by R.Karimi and Dr A. Manikas
% Ref.: PhD thesis: J.Dacos 1991;
%       PhD thesis: R.Karimi 1993;
%........................................................................ 


%-------------------------MANIFOLD----------------------------
a=spv(array,direction);
[at,ap]=spvd(array,direction);
[att,app,atp]=spvdd(array,direction);

%----------------Rates of Change of Arc Length----------------
  
st = norm(at);              stt = real(at'*att)/st;
sp = norm(ap);              spp = real(ap'*app)/sp;

%---------------Coordinate Vectors and Curvature--------------
%.....theta-lines       
u1 = at / st     ;             u1pr = (st*att - stt*at)/st^3;
k1 = norm( u1pr );             u2   = u1pr/k1               ;

Tinclination=fcvvangle(u1,u2);      %in degrees
k1inc = k1 * sin(Tinclination*pi/180);     %<<<< Inclination

Ut  = [u1 u2];
Tcurvature=[k1,k1inc];

%.....phi-lines
u1 = ap / sp     ;             u1pr = (sp*app - spp*ap)/sp^3;
k1 = norm( u1pr );             u2   = u1pr/k1               ;

Pinclination=fcvvangle(u1,u2);      %in degrees
k1inc = k1 * sin(Pinclination*pi/180);     %<<<< Inclination

Up  = [u1 u2];
Pcurvature=[k1,k1inc];

%.............................................

curvature1=[Tcurvature;Pcurvature];
ds=[st;sp];
inclination=[Tinclination;Pinclination];
