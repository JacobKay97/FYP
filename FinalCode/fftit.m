function fftit(input, samplerate)

N=size(input,1);
freq = zeros(N,1);

fVector=(-samplerate/2):(samplerate/(size(input,2)-1)):(samplerate/2);
for i=1:N
    raw_fft = fft(input(i,:));
    shifted_fft = fftshift(raw_fft);
    figure;
    title("FFT of Node " + num2str(i))
    plot(fVector, 10*log10(abs(shifted_fft) ));
    xlabel("Frequency [Hz]")
    ylabel("Amplitude [dB]")
end

end
