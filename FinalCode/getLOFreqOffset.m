function [freqoffset, averagePhase] = getLOFreqOffset (symbolsIn, plotting,SAMPLERATE)


TIMESTEP = 1/SAMPLERATE;
unwrap_tol = [];
phase = unwrap(angle(symbolsIn),unwrap_tol,2);

NoSymbols = size(symbolsIn,2);
N = size(symbolsIn,1);
totalTime = NoSymbols*TIMESTEP;
coeffs = zeros(N,2);
timeVector = 0:TIMESTEP:totalTime-TIMESTEP;

for i=1:N
    coeffs(i,:) = polyfit(timeVector,phase(i,:),1);
    y(i,:) = polyval(rad2deg(coeffs(i,:)),timeVector);
end

freqoffset = coeffs(:,1);
averagePhase = coeffs(:,2);

if plotting == 1
    figure
    grid on;
    hold on
    plot(rad2deg(phase(1,:)), 'Color', [0 0.4470 0.7410]);
    plot(rad2deg(phase(2,:)), 'Color', [0.8500 0.3250 0.0980]);
    plot(rad2deg(phase(3,:)), 'Color', [0.9290 0.6940 0.1250]);
    plot(rad2deg(phase(4,:)), 'Color', [0.4940 0.1840 0.5560]);
    plot(rad2deg(phase(5,:)), 'Color', [0.4660 0.6740 0.1880]);
    plot(y(1,:), '--', 'Color', [0 0.4470 0.7410]);
    plot(y(2,:), '--', 'Color', [0.8500 0.3250 0.0980]);
    plot(y(3,:), '--', 'Color', [0.9290 0.6940 0.1250]);
    plot(y(4,:), '--', 'Color', [0.4940 0.1840 0.5560]);
    plot(y(5,:), '--', 'Color', [0.4660 0.6740 0.1880]);
    ylabel('Phase (deg)')
    xlabel('Sample Number')
    legend('Node 1', 'Node 2', 'Node 3', 'Node 4', 'Node 5');
    title('Unwrapped phase of raw signal, pre LO frequency calibration')
end

end
