function timeCourseIllustration(data, isVertical, frames, fit)
    data = findPeak(data);
    
    figure
    for frame = frames        
        [distances, yFit] = doOneFit(data, frame, isVertical, fit);
        plot(distances,yFit)
        hold on
    end
    title(sprintf('%s - %s %s for several frames', data.sessionKey, sliceName(isVertical), fit.name()))
    xlabel('distance from peak [mm]')
    ylabel('relative signal')
end

function [distances, yFit] = doOneFit(data, frame, isVertical,fit)
    W = 9;
    signal = relativeSignal(data.blank, data.stims, frame);
    [eqMeans, ~, eqVals] = sliceStats(signal, data.mask, data.C, W, isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    yAll = mean(eqMeans,1);
    P = fit.fitParams(distances,yAll);
    yFit = fit.fitValues(distances,P);
end