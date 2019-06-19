function fftit(input, samplerate)

raw_fft = fft(input);
shifted_fft = fftshift(raw_fft);
fVector=[((-samplerate+0)/2):(samplerate/(size(input,2)-1)):((samplerate-0)/2)];
figure
% plot(fVector, 20*log10(abs(shifted_fft) ));
plot(fVector, (abs(shifted_fft) ));
end
