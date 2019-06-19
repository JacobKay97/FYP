function freq = fft_peak(input, samplerate,refNode, plotting)

N=size(input,1);
freq = zeros(N,1);

fVector=(-samplerate/2):(samplerate/(size(input,2)-1)):(samplerate/2);
fvectorSize= length(fVector);
fVectorMidpos = round((fvectorSize/2) + 15);
fVectorMidneg = round((fvectorSize/2) - 15);
for i=1:N
    raw_fft = fft(input(i,:));
    shifted_fft = fftshift(raw_fft);

    if(plotting ==1)
        figure;
        title("FFT of Node " + num2str(i))
        plot(fVector, (abs(shifted_fft) ));
        ylabel("Frequency [Hz]")
        xlabel("Amplitude")
    end

    [~, freq(i)] = findpeaks((abs([shifted_fft(1:fVectorMidneg) shifted_fft(fVectorMidpos:end)]) ),[fVector(1:fVectorMidneg) fVector(fVectorMidpos:end)],'NPeaks', 1, 'SortStr', 'descend');
end

if(refNode~=0)
    freq(refNode) = 0;
end

end

