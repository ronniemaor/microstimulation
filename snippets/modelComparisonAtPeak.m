function modelComparisonAtPeak(data, fits)
    data = findPeak(data);
    peakRange = data.peakFrame; % rangeFromWidth(data.peakFrame,3);
    signal = relativeSignal(data.blank,data.stims,peakRange);
    W = 9;
    nBins = 2;    
    fitNames = cellfun(@(fit) fit.name(), fits, 'UniformOutput',false);
    nFits = length(fits);

    nSlices = 2;
    errCases = zeros(nSlices,nFits);
    errSemCases = zeros(nSlices,nFits);
    sliceNames = cell(1,nSlices);

    figure
    for iSlice = 1:2
        vertical = iSlice == 2;
        if vertical; strAxis='Vertical'; else strAxis='Horizontal'; end;
        sliceNames{iSlice} = strAxis;
        [eqMeans, eqStd, eqVals] = ...
            sliceStats(signal,data.mask,data.C,W,vertical);
        mmPerPixel = 0.1;
        distances = eqVals * mmPerPixel; % convert to mm
        eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials

        subplot(2,2,iSlice)
        errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
        hold on
        colors = get(gca,'ColorOrder');

        for iFit = 1:nFits
            fit = fits{iFit};
            [yFit,P,err,errSem, overfitR2] = ...
                   crossValidationRegression(fit,distances,eqMeans,nBins);
            errCases(iSlice,iFit) = err;
            errSemCases(iSlice,iFit) = errSem;
            plot(distances, yFit, 'Color', colors(iFit+1,:));
            title(sprintf('%s slice',strAxis));
            xlabel('Distance from peak center (mm)'); 
            ylabel('Relative signal');
        end
        legend('Measured values', fitNames{:});
    end

    subplot(2,2,[3 4])
    barwitherr(errSemCases, errCases);
    title('Goodness of fit for the different models');
    set(gca,'XTickLabel',sliceNames)
    ylabel('R2')
    legend(fitNames,'Location','North')

    topVals = errCases + errSemCases;
    bottomVals = errCases - errSemCases;
    ymax = max(topVals(:));
    ymin = min(bottomVals(:));
    ylim([max(0,ymin-0.2), min(1,ymax+0.05)])

    if length(peakRange) > 1
        strFrames = sprintf('frames %d:%d', min(peakRange), max(peakRange));
    else
        strFrames = sprintf('frame %d', peakRange);
    end
    t = sprintf('Fits for %s, W=%d, C=(%d,%d)', strFrames, W, data.C(1), data.C(2));
    topLevelTitle(t);
end
