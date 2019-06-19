function [out] = filterit(input,CUTOFF, SAMPLERATE)




    for(i = 1:5)
        out(i,:) = lowpass( real(input(i,:)), CUTOFF, SAMPLERATE) + 1i*lowpass( imag(input(i,:)), CUTOFF, SAMPLERATE);
    end

end
