clear;
close all;
directory = '../NewData/20190531/';
ref_node = 1;

SAMPLERATE = 192000;
TIMESTEP = 1/SAMPLERATE;
CUTOFF = 4000;
N = 5;


[rx, rx_cut, rx_cut_ref, testName] = loadNodeData_mat (directory, ref_node, 11,SAMPLERATE, N);
array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0] + [2,0,0];
 DOA = [60,0];
rx_sample = rx_cut(:,1000:1499);
figure;
plot(rad2deg(angle(rx_sample.')));
title('Phase of raw received signal, pre reference node');
ylabel('Phase (deg)')
xlabel('Sample Number')
legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
%saveas(1,'..\Final Report\MEng_Project_Report_template\figures\60degPhasePlotPre','epsc')


rx_sample = rx_cut_ref(:,1000:1499);
figure
plot(rad2deg(angle(rx_sample.')));
title('Phase of raw received signal, post reference node');
ylabel('Phase (deg)')
xlabel('Sample Number')
legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
%saveas(2,'..\Final Report\MEng_Project_Report_template\figures\60degPhasePlot','epsc')


[rx_sample_out, coeffs] = LoCorrectionLin_reportgraph(rx_sample,1,192000);

[phaseOffset] = getPhaseOffset (coeffs(:,2), array,DOA);
%saveas(3,'..\Final Report\MEng_Project_Report_template\figures\60degPhasePlot_Lin_correction','epsc')
%saveas(4,'..\Final Report\MEng_Project_Report_template\figures\60degPhasePlot_Lin_corrected','epsc')

[phaseCorrectedSymbols] = LoCorrection(rx_sample, coeffs(:,1),phaseOffset, 1,SAMPLERATE);

%saveas(6,'..\Final Report\MEng_Project_Report_template\figures\60degPhasePlot_Lin_correctedFully','epsc')

[gainCorrectedSymbols] = gainCorr(phaseCorrectedSymbols, 1,ref_node);
 
%saveas(7,'..\Final Report\MEng_Project_Report_template\figures\60degMagnitudeBeforeCorr','epsc')
%saveas(8,'..\Final Report\MEng_Project_Report_template\figures\60degMagnitudecorrectedFully','epsc')


SV_ref =rx_sample;
SV_LO = rx_sample_out;
SV_LOphase = phaseCorrectedSymbols;
SV_LOphasegain = gainCorrectedSymbols;
Rxx_ref=SV_ref*SV_ref'/length(SV_ref);
Rxx_LO=SV_LO*SV_LO'/length(SV_LO);
Rxx_LOphase=SV_LOphase*SV_LOphase'/length(SV_LOphase);
Rxx_LOphasegain=SV_LOphasegain*SV_LOphasegain'/length(SV_LOphasegain);
M = 1;
Azarea=0:0.1:180;
Z_ref = music(Rxx_ref,array,M,Azarea,0);
Z_LO = music(Rxx_LO,array,M,Azarea,0);
Z_LOphase = music(Rxx_LOphase,array,M,Azarea,0);
Z_LOphasegain = music(Rxx_LOphasegain,array,M,Azarea,0);

figure;
hold on;
plot(Azarea,Z_ref);
plot(Azarea,Z_LO);
plot(Azarea,Z_LOphase);
plot(Azarea,Z_LOphasegain);
grid on;
title('MUSIC spectrum for a source from (60,0), showing calibration effects') 
xlabel('Azimuth (degrees)')
ylabel('dB')     
legend('Uncorrected','LO F', 'LO Freq and phase', 'LO Freq, Phase, and Gain')
hold off
saveas(9,'..\Final Report\MEng_Project_Report_template\figures\60degMUSICm1','epsc')






fc = 800e6;
c = physconst('LightSpeed');
lam = c/fc;
d = 0.5*lam;
sIso = phased.IsotropicAntennaElement('FrequencyRange',[700,900]*1e6);
Nelem = 5;
NominalTaper = ones(1,Nelem);
sULA = phased.ULA('Element',sIso,'NumElements',Nelem,'ElementSpacing',d,...
    'Taper',NominalTaper, 'ArrayAxis', 'x');

PilotAng = DOA.';
x = rx_sample.';
nomtaper = ones(size(x,2),1);

NominalElementPositions = getElementPosition(sULA)/lam;
ReferenceElement = NominalElementPositions(:,1);

uncerts = [1;0;0;0];
[estpos_raw,esttaper_raw] = pilotcalib((NominalElementPositions - ReferenceElement*ones(1,Nelem)),             rx_sample.',PilotAng,nomtaper,uncerts);

[estpos_LoPhaseGain,esttaper_LoPhaseGain] = pilotcalib((NominalElementPositions - ReferenceElement*ones(1,Nelem)),gainCorrectedSymbols.',PilotAng,nomtaper,uncerts);

array = (estpos_raw + NominalElementPositions(:,1)*ones(1,Nelem)).'*-2;
array2 = (estpos_LoPhaseGain + NominalElementPositions(:,1)*ones(1,Nelem)).'*-2;

SV_ref =rx_sample./esttaper_raw;

SV_LOphasegain = gainCorrectedSymbols./esttaper_LoPhaseGain;
Rxx_ref=SV_ref*SV_ref'/length(SV_ref);

Rxx_LOphasegain=SV_LOphasegain*SV_LOphasegain'/length(SV_LOphasegain);
M = 1;
Azarea=[50:0.001:70];
%Azarea=[0:0.1:180];
Z_ref = music(Rxx_ref,array,M,Azarea,0);

Z_LOphasegain = music(Rxx_LOphasegain,array,M,Azarea,0);

figure;
hold on;
plot(Azarea,Z_ref);
plot(Azarea,Z_LOphasegain);
grid on;
title('MUSIC spectrum for a source from (60,0), after Pilot Calibration') 
xlabel('Azimuth (degrees)')
ylabel('dB')     
legend('Uncorrected','LO Freq, Phase, and Gain')
hold off

saveas(10,'..\Final Report\MEng_Project_Report_template\figures\60degMUSICpostpilot','epsc')