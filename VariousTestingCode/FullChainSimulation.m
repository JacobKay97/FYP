clear;
close all;

SAMPLERATE = 192000;
TIMESTEP = 1/SAMPLERATE;
CUTOFF = 4000;
array = [-2,0,0;-1,0,0;0,0,0;1,0,0;2,0,0];
array = array - array(1,:)
N = 5;
txFreq = 800e6;
rxFreq = [799.97, 800.001, 800, 799.978];
totalTime = 1;

timeMatx = 0:TIMESTEP:1-TIMESTEP;

%Tx = 1*sin(2*pi*txFreq.*timeMatx);

S = spv(array,[90,0;60,0;30,0]);
phase_test = (angle(S));
abs(S)