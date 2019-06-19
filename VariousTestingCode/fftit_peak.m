function freqs = fftit_peak(input, samplerate)

raw_fft = fft(input);
shifted_fft = fftshift(raw_fft);
freqaxis=[((-samplerate)/2):(samplerate/(size(input,2)-1)):((samplerate)/2)];
%figure
% plot(fVector, 20*log10(abs(shifted_fft) ));

plot(freqaxis, (abs(shifted_fft) ));

% [~, freqs] = findpeaks((abs(shifted_fft) ),fVector,'NPeaks', 1, 'SortStr', 'descend');

fvectorSize= length(freqaxis);
fVectorMidpos = round((fvectorSize/2) + 15);
fVectorMidneg = round((fvectorSize/2) - 15);

[~, freqs] = findpeaks((abs([shifted_fft(1:fVectorMidneg) shifted_fft(fVectorMidpos:end)]) ),[freqaxis(1:fVectorMidneg) freqaxis(fVectorMidpos:end)],'NPeaks', 1, 'SortStr', 'descend');
end

