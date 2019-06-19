function [phaseCorrectedSymbols, p] = LoCorrectionLin (symbolsIn, plotting)


%% Paramaters

SAMPLERATE = 192000;
TIMESTEP = 1/SAMPLERATE;

phase = unwrap(angle(symbolsIn),[],2);

NoSymbols = size(symbolsIn,2);
N = size(symbolsIn,1);
totalTime = NoSymbols*TIMESTEP;
p = zeros(N,2);
timeVector = 0:TIMESTEP:totalTime-TIMESTEP;

for i=1:N
    p(i,:) = polyfit(timeVector,phase(i,:),1);
end

gradients = p(:,1);

phaseCorrection = repmat(timeVector, N, 1);
phaseCorrection = exp(-1j.*(gradients.*phaseCorrection)); %(-j*2pi*f*t);
phaseCorrectedSymbols = symbolsIn.*phaseCorrection;


correctSymbolsPhase = unwrap(angle(phaseCorrectedSymbols),[],2);
averagePhase = p(:,2);

finalCorrected =  phaseCorrectedSymbols .* exp( -1j.*averagePhase);

%phaseCorrectedSymbols = finalCorrected;
%correctSymbolsPhase = unwrap(angle(phaseCorrectedSymbols),[],2);
if plotting == 1
    figure
    subplot(1,2,1);
    plot(rad2deg(phase.'))
    grid on;
    ylabel('Phase (deg)')
    xlabel('Sample number')
    legend('1','2','3','4','5')
    subplot(1,2,2);
    plot(rad2deg(correctSymbolsPhase.'));
    grid on;
    ylabel('Phase (deg)')
    xlabel('Sample number')
    legend('1','2','3','4','5')
    
end



end
