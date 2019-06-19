clear;
close all;
directory = '../NewData/20190613/';

REF_NODE = 1;
SAMPLERATE = 192000;
TIMESTEP = 1/SAMPLERATE;
N = 5;

array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0];

DOA = [90,0];
[rawRx, rx_cut, rx_cut_ref, testName] = loadNodeData_wav (directory, REF_NODE, 1, SAMPLERATE, N);

rx_cut_ref = rx_cut_ref(:,1000:end); %Removing first 1000 samples as phase is usually strange.

rx_sample = rx_cut_ref(:,1:200000); %Take small sample of signal.


[freqoffset, averagePhase] = getLOFreqOffset (rx_sample, 1,SAMPLERATE);

[phaseOffset] = getPhaseOffset (averagePhase, array,DOA);

[rx_cut_ref_phaseCorrected] = LoCorrection(rx_cut_ref, freqoffset, phaseOffset, 1,SAMPLERATE);

[gainCorrectedSymbols] = gainCorr(rx_cut_ref_phaseCorrected, 1,REF_NODE);
L=500;
for i = 1:5
SV_ref = rx_cut_ref(:,(i-1)*L + 1:(i)*L);
SV_phase = rx_cut_ref_phaseCorrected(:,(i-1)*L + 1:(i)*L);
SV_phasegain = gainCorrectedSymbols(:,(i-1)*L + 1:(i)*L);
Rxx_ref=SV_ref*SV_ref'/length(SV_ref);
Rxx_phase=SV_phase*SV_phase'/length(SV_phase);
Rxx_phasegain=SV_phasegain*SV_phasegain'/length(SV_phasegain);
M = 1;
Azarea=0:0.1:180;
Z_ref = music(Rxx_ref,array,M,Azarea,0);
Z_phase = music(Rxx_phase,array,M,Azarea,0);
Z_phasegain = music(Rxx_phasegain,array,M,Azarea,0);

figure;
hold on;
plot(Azarea,Z_ref);
plot(Azarea,Z_phase);
plot(Azarea,Z_phasegain);
grid on;
xlabel('Azimuth (degrees)')
ylabel('dB')     
legend('Raw ref', 'Phase corrected', 'Phase and gain corrected')
hold off
end

