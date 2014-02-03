function presentationFitSeveralTimes(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    data = loadData('M18c',parms);
    data = findPeak(data);
    isVertical = 0;
    fit = GaussianFit;
    frames = [26 27 32];
    for i = 1:length(frames)
        showFits(data, isVertical, fit, frames(1:i))
    end
end
    
function showFits(data, isVertical, fit, frames)    
    figure
    set(gca,'FontSize',18)
    for frame = frames        
        [distances, yFit] = doOneFit(data, frame, isVertical, fit);
        plot(distances,yFit)
        hold on
    end    
    xlabel('distance from peak [mm]')
    ylabel('relative signal')
    xlim([0 5])
    ylim([0 1.9e-3])
end

function [distances, yFit] = doOneFit(data, frame, isVertical,fit)
    W = 9;
    signal = data.signal(:,frame,:);
    [eqMeans, ~, eqVals] = sliceStats(signal, data.mask, data.C, W, isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    yAll = mean(eqMeans,1);
    P = fit.fitParams(distances,yAll);
    yFit = fit.fitValues(distances,P);
end