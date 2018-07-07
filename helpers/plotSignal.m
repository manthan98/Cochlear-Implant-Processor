function plotSignal( numSamples, signal )
%PLOTSIGNAL Summary of this function goes here
%   Detailed explanation goes here
    sampleNumVector = linspace(1, numSamples, numSamples);
    figure;
    plot(sampleNumVector, signal);
end

