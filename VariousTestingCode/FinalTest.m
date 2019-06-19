clear;
close all;
directory = '../NewData/20190613/';
ref_node = 1;

SAMPLERATE = 192000;
TIMESTEP = 1/SAMPLERATE;
CUTOFF = 4000;
N = 5;


[rx, rx_cut, rx_cut_ref, testName, startTime] = loadNodeData_v2Audio (directory, ref_node, 1);
array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0];



rx_sample = rx_cut_ref(:,1000:1499);
rx_sample_full = rx_cut_ref(:,1000:end);
figure
plot(rad2deg(angle(rx_sample.')));
title('Phase of raw received signal');
ylabel('Phase (deg)')
xlabel('Sample Number')
legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');

[rx_sample_out, coeffs] = LoCorrectionLin_reportgraph(rx_sample,1,192000);
[rx_sample_out, coeffs] = LoCorrectionLin_reportgraph(rx_sample_full(:,1:278100),1,192000);

timeMatx = repmat(0:TIMESTEP:(length(rx_cut_ref)-1000)*TIMESTEP, N, 1);
LOCorrection = exp(-1j.*(coeffs(:,1).*timeMatx+coeffs(:,2)));

rx_final = rx_sample_full.*LOCorrection;
plot(angle(rx_final(:,1:499).'))
MusicLength = 300;
for i = 1:100:1000
SV_90 = rx_final(:,(i-1)*MusicLength + 1:(i)*MusicLength);


Rxx_90=SV_90*SV_90'/length(SV_90);L=length(SV_90);
[Rxx_90, temp] = fSpatialSmoothing(rx_final(:,(i-1)*MusicLength + 1:(i)*MusicLength),4);

%array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0];
array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0];
M = 4;
Azarea=0:0.1:180;
Z_90 = music(Rxx_90,array,M,Azarea,0);
figure;
hold on;
plot(Azarea,Z_90);
grid on;
xlabel('Azimuth (degrees)')
ylabel('dB') 
hold off;
    
end

