function presentationCreateSliceResultAndResiduals(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    data = loadData('M18c',parms);
    data = findPeak(data);
    isVertical = 1;
    fit = GaussianFit;
    
    [distances, yAll, ySEM, yFit] = doOneFit(data, data.peakFrame, isVertical, fit);
    figure
    errorbar(distances, yAll, ySEM, '.g');
    setPlotAxes()

    figure
    plot(distances,yAll,'ro')    
    hold on
    for i=1:length(distances)
        d = distances(i);
        plot([d d],[yAll(i) yFit(i)], 'r')
    end
    plot(distances,yFit,'b')
    setPlotAxes()
end

function setPlotAxes()
    set(gca,'FontSize',18)
    xlabel('distance from peak [mm]')
    ylabel('relative signal')
    xlim([0 4.5])
end

function [distances, yAll, ySEM, yFit] = doOneFit(data, frame, isVertical, fit)
    W = 9;
    signal = data.signal(:,frame,:);
    [eqMeans, eqStd, eqVals] = sliceStats(signal, data.mask, data.C, W, isVertical);
    ySEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    yAll = mean(eqMeans,1);
    P = fit.fitParams(distances,yAll);
    yFit = fit.fitValues(distances,P);
end