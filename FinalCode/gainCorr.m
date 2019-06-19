function [gainCorrectedSymbols] = gainCorr(symbolsIn, plotting,refNode)

desiredrms = 0.25;
desiredOffset = 1.0;

symbolsMag = abs(symbolsIn);
symbolsPhase = angle(symbolsIn);


average_gain = mean(symbolsMag,2);
offsetMag = symbolsMag - average_gain;
rms_sig = rms(offsetMag,2);
if(refNode~=0)
    rms_sig(refNode) = desiredrms;
end
rmscorrected = offsetMag.* (desiredrms./rms_sig);
rms(rmscorrected,2)
rms(offsetMag,2)
correctedMag = rmscorrected + desiredOffset;

gainCorrectedSymbols = abs(correctedMag).*exp(1j*symbolsPhase);

if (plotting==1)
    figure;
    plot(symbolsMag.');
    legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
    xlabel('Sample Number')
    ylabel('Magnitude')
    title('Magnitude of signal before gain calibration')
    grid on;
    
    figure;
    plot(correctedMag.');
    legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
    xlabel('Sample Number')
    ylabel('Magnitude')
    title('Magnitude of signal after gain calibration')
    grid on;
    
end

end
