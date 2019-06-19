function [phaseOffset] = getPhaseOffset (averagePhase, array,DOA)

expectedPhase = angle(spv(array,DOA));
phaseOffset = averagePhase - expectedPhase;

end
