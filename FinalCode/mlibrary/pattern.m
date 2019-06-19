function Z=pattern(SENSORS,w,AZarea,ELarea,dB,mainlobe);
%.......................................................
% Z=pattern(SENSORS,w,AZarea,ELarea,dB,mainlobe);
% estimates the array pattern of a number of N sensors
% N.B.: the pattern can be plotted by using plpattern.m
% written by Dr A. Manikas (IC)
%.......................................................
if nargin<2, w=[]; end;
if w==[] 
   w=ones(size(SENSORS(:,1)));
end;

if nargin<6
   mainlobe=[];
   if nargin<5
      dB=1;
      if nargin<4
         ELarea=0;
         if nargin<3
            AZarea=0:1:180;
         end;
      end;
   end;
end;


Z=[];
az=AZarea';

for el=ELarea;
    home; el
    S=spv(SENSORS,[az,el*ones(size(az))],mainlobe);
    Z=[Z;abs(w'*S)];
end;



