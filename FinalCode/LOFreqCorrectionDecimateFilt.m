function [LoFreqCorrectedSymbols] = LOFreqCorrectionDecimateFilt(symbolsIn,freqoffset, plotting, SAMPLERATE)

TIMESTEP = 1/SAMPLERATE;
cutoff = 400;
dec = 16;

NoSymbols = size(symbolsIn,2);
N = size(symbolsIn,1);
totalTime = NoSymbols*TIMESTEP;

symbols_dec = zeros(N, ceil(NoSymbols/dec));
symbols_filt = zeros(N, ceil(NoSymbols/dec));
symbols_up = zeros(N, ceil(NoSymbols/dec)*dec);
maxFOffset = max(abs(freqoffset));

maxDecimation = floor(SAMPLERATE/ (2*maxFOffset));


timeVector = 0:TIMESTEP:totalTime-TIMESTEP;
timeMatx = repmat(timeVector, N, 1);
phaseCorrection = exp(-1j.*(2*pi*freqoffset.*timeMatx)); %(-j*(2pi*f*t));
phaseCorrectedSymbols = symbolsIn.*phaseCorrection;

   
for i = 1:N
    symbols_dec(i,:) = decimate(phaseCorrectedSymbols(i,:),dec);
end


for i = 1:N
   symbols_filt(i,:) = lowpass(symbols_dec(i,:),cutoff,SAMPLERATE/dec);
end

for i = 1:N
   symbols_up(i,:) = interp(symbols_dec(i,:),dec);
end
LoFreqCorrectedSymbols = symbols_up;

if(plotting ==1)
    fftit(phaseCorrectedSymbols, SAMPLERATE);
    fftit(symbols_dec, SAMPLERATE/dec);
    fftit(symbols_filt, SAMPLERATE/dec);
    fftit(symbols_up, SAMPLERATE);
elseif(plotting==3)
    fftit(symbolsIn(3,:), SAMPLERATE);
    fftit(phaseCorrectedSymbols(3,:), SAMPLERATE);
    fftit(symbols_dec(3,:), SAMPLERATE/dec);
    fftit(symbols_filt(3,:), SAMPLERATE/dec);
    fftit(symbols_up(3,:), SAMPLERATE);
end

end
