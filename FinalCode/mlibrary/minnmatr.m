function best = minmatr(Z, AZarea, ELarea, n)

%  best = minnmatr(Z, AZarea, ELarea, n)
%  The Lowest n-Mins of a Matrix Z
%  Z      ... Result of MUSIC
%  AZarea ... x axis (Azimuth Area)
%  ELarea ... y axis (Elevation area)
%  n      ... The number of minimum points required
%  Example best = minnmatr(Z, 1:1:180, 0:5:90, 3)
%
%  Digital Communications Section, EEED, IC
%  Written by : Nobuyuki Takai
%  Supervisor : Dr A. Manikas
%  18 April 1994

Z     = Z';
best  = [];
ON    = 1;
OFF   = 0;
flagN = OFF;
flagS = OFF;
flagW = OFF;
flagE = OFF;
[lenaz,lenel] = size(Z);
 
for el=1:lenel
    for az=1:lenaz
        home; fprintf('az=%f\nel=%f\n',AZarea(az),ELarea(el));
                    C = Z(az,el);
        if az>1     N = Z(az-1,el); end;
        if az<lenaz S = Z(az+1,el); end;
        if el>1     W = Z(az,el-1); end;
        if el<lenel E = Z(az,el+1); end;
% North
        if az>1
            if C<=N
                flagN = ON;
            end;
        else
            flagN = ON;
        end;
% South
        if az<lenaz
            if C<=S
                flagS = ON;
            end;
        else
            flagS = ON;
        end;
% WZ
        if el>1
            if C<=W
                flagW = ON;
            end;
        else
            flagW = ON;
        end;
% East
        if el<lenel
            if C<=E
                flagE = ON;
            end;
        else
            flagE = ON;
        end;
% Decision
        if (flagN)&(flagS)&(flagW)&(flagE) 
            pits = [pits; [az el]];
        end;
% Initialize Flags
        flagN = OFF;
        flagS = OFF;
        flagW = OFF;
        flagE = OFF;
    end;
end;

for a=1:length(pits)
    vals(a) = Z(pits(a,1),pits(a,2));
end;

[sorted index] = sort(vals);
if n<length(index)
    index  = index (1:n);
    sorted = sorted(1:n);
end;
pointer = pits(index,:);

az   = AZarea(pointer(:,1));
el   = ELarea(pointer(:,2));
best = [az' el' sorted'];


