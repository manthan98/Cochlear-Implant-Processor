function plotSignal(numSamples, signal, xDesc, yDesc)
%   PLOTSIGNAL plots a signal with particular styling.

    sampleNumVector = linspace(1, numSamples, numSamples);
    figure;
    plot(sampleNumVector, signal);
    xlabel(xDesc);
    ylabel(yDesc);
end