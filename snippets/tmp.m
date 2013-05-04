function tmp()
    data = loadData('J29c');
    data = findPeak(data);
    isVertical = 1;
    fit = GaussianFit;
    
    figure
    [distances, yAll, yFit] = doOneFit(data, data.peakFrame, isVertical, fit);
    yscale = max(yAll);
    xscale = max(distances);
    yAll = yAll / yscale;
    yFit = yFit / yscale;
    distances = distances / xscale;
    plot(distances, yAll, 'rx')
    hold on
    plot(distances,yFit,'b')
end

function [distances, yAll, yFit] = doOneFit(data, frame, isVertical, fit)
    W = 9;
    signal = relativeSignal(data.blank, data.stims, frame);
    [eqMeans, ~, eqVals] = sliceStats(signal, data.mask, data.C, W, isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    yAll = mean(eqMeans,1);
    P = fit.fitParams(distances,yAll);
    yFit = fit.fitValues(distances,P);
end