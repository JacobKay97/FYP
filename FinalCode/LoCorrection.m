function [phaseCorrectedSymbols] = LoCorrection(symbolsIn, freqoffset, phaseOffset, plotting,SAMPLERATE)

TIMESTEP = 1/SAMPLERATE;

NoSymbols = size(symbolsIn,2);
N = size(symbolsIn,1);
totalTime = NoSymbols*TIMESTEP;

timeVector = 0:TIMESTEP:totalTime-TIMESTEP;
timeMatx = repmat(timeVector, N, 1);
phaseCorrection = exp(-1j.*(freqoffset.*timeMatx + phaseOffset)); %(-j*(2pi*f*t+phi));
phaseCorrectedSymbols = symbolsIn.*phaseCorrection;

correctSymbolsPhase = unwrap(angle(phaseCorrectedSymbols),[],2);
phase = unwrap(angle(symbolsIn),[],2);
if plotting == 1
    for i=1:N
       y2(i,:) = polyval(rad2deg(phaseOffset(i)),timeVector);
    end
    figure
    grid on;
    hold on
    plot(rad2deg(phase(1,:)), 'Color', [0 0.4470 0.7410]);
    plot(rad2deg(phase(2,:)), 'Color', [0.8500 0.3250 0.0980]);
    plot(rad2deg(phase(3,:)), 'Color', [0.9290 0.6940 0.1250]);
    plot(rad2deg(phase(4,:)), 'Color', [0.4940 0.1840 0.5560]);
    plot(rad2deg(phase(5,:)), 'Color', [0.4660 0.6740 0.1880]);
    ylabel('Phase (deg)')
    xlabel('Sample Number')
    legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
    title('Unwrapped phase of signal, before LO frequency calibration')
    
    figure;
    hold on;
    plot(rad2deg(correctSymbolsPhase(1,:)), 'Color', [0 0.4470 0.7410]);
    plot(rad2deg(correctSymbolsPhase(2,:)), 'Color', [0.8500 0.3250 0.0980]);
    plot(rad2deg(correctSymbolsPhase(3,:)), 'Color', [0.9290 0.6940 0.1250]);
    plot(rad2deg(correctSymbolsPhase(4,:)), 'Color', [0.4940 0.1840 0.5560]);
    plot(rad2deg(correctSymbolsPhase(5,:)), 'Color', [0.4660 0.6740 0.1880]);


    grid on;
    title('Unwrapped phase of signal, after LO frequency and phase calibration')
    ylabel('Phase (deg)')
    xlabel('Sample Number')
    legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
    lgd.NumColumns = 5;
    ylim([-280 +280]);
end

end
