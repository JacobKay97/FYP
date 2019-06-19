function [phaseCorrectedSymbols] = getLOFreqOffset (symbolsIn, plotting)

%% Main changes
% No longer take in start and end sample
% Take in time

%% Paramaters

SAMPLERATE = 192000;
TIMESTEP = 1/SAMPLERATE;



phase = unwrap(angle(symbolsIn),[],2);

NoSymbols = size(symbolsIn,2);
N = size(symbolsIn,1);
totalTime = NoSymbols*TIMESTEP;


dt = NoSymbols*TIMESTEP;
gradients = ( phase(:,NoSymbols) - phase(:,1)  ) / dt;


phaseCorrection = repmat(0:TIMESTEP:totalTime-TIMESTEP, N, 1);
phaseCorrection = exp(-1j.*(gradients.*phaseCorrection)); %(-j*2pi*f*t);

phaseCorrectedSymbols = symbolsIn.*phaseCorrection;

%To do - average of the phase corrected symbols  - mean(data, 2) - second

%then e(-j*angle) them
correctSymbolsPhase = unwrap(angle(phaseCorrectedSymbols),[],2);
averagePhase = mean(correctSymbolsPhase,2);
rad2deg(averagePhase)
finalCorrected =  phaseCorrectedSymbols .* exp( -1j.*averagePhase);

phaseCorrectedSymbols = finalCorrected;
if plotting == 1
    figure
    subplot(1,2,1);
    plot(rad2deg(unwrap(angle(symbolsIn.'))))
    grid on;
    ylabel('Phase (deg)')
    xlabel('Sample number')
    legend('1','2','3','4','5')
    subplot(1,2,2);
    plot(rad2deg(unwrap(angle(phaseCorrectedSymbols.'))));
    grid on;
    ylabel('Phase (deg)')
    xlabel('Sample number')
    legend('1','2','3','4','5')
    
    figure
    subplot(1,2,1);
    plot(rad2deg(unwrap(angle(phaseCorrectedSymbols.'))))
    grid on;
    ylabel('Phase (deg)')
    xlabel('Sample number')
    legend('1','2','3','4','5')
    subplot(1,2,2);
    plot(rad2deg(unwrap(angle(finalCorrected.'))));
    grid on;
    ylabel('Phase (deg)')
    xlabel('Sample number')
    legend('1','2','3','4','5')
    
    
    if dt < 1500/192000
        figure
        subplot(1,2,1);
        plot(abs(symbolsIn.'))
        grid on;
        ylabel('mag')
        xlabel('Sample number')
        legend('1','2','3','4','5')
        subplot(1,2,2);
        plot(abs(phaseCorrectedSymbols.'));
        grid on;
        ylabel('mag')
        xlabel('Sample number')
        legend('1','2','3','4','5')
    end
end



end
