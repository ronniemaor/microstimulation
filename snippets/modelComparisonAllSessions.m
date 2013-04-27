function modelComparisonAllSessions(fits)
    fitNames = cellfun(@(fit) fit.name(), fits, 'UniformOutput',false);
    nFits = length(fits);
    
    allSessions = getAllSessionConfigs();
    nSessions = length(allSessions);
    nSlices = 2;
    sliceNames = cell(1,nSlices);

    err = zeros(nSessions, nSlices, nFits);
    errSem = zeros(nSessions, nSlices, nFits);
    sessionNames = cell(1,nSessions);

    iSession = 0;
    for cSession = allSessions.keys()
        iSession = iSession + 1;
        sessionKey = cSession{1};
        sessionNames{iSession} = sessionKey;
        data = loadData(sessionKey);
        data = findPeak(data);
        signal = relativeSignal(data.blank,data.stims,data.peakFrame);
        for iSlice = 1:2
            isVertical = iSlice == 2;
            sliceNames{iSlice} = sliceName(isVertical);
            for iFit = 1:nFits
                fit = fits{iFit};
                [thisErr, thisErrSem] = goodnessOfFit(signal, data.mask, data.C, isVertical, fit);
                err(iSession,iSlice,iFit) = thisErr;
                errSem(iSession,iSlice,iFit) = thisErrSem;
            end
        end            
    end

    topVals = err + errSem;
    bottomVals = err - errSem;
    ymax = max(topVals(:));
    ymin = min(bottomVals(:));
    
    figure
    for iSlice = 1:2
        subplot(2,1,iSlice)
        sliceErr = squeeze(err(:,iSlice,:));
        sliceErrSem = squeeze(errSem(:,iSlice,:));
        barwitherr(sliceErrSem, sliceErr);
        title(sprintf('%s slices',sliceNames{iSlice}));
        set(gca,'XTickLabel',sessionNames)
        ylabel('R2')
        legend(fitNames,'Location','NorthEastOutside')
        ylim([max(0,ymin-0.2), min(1,ymax+0.05)])
    end

    topLevelTitle('Model comparison across sessions');
end

function [err, errSem] = goodnessOfFit(signal, mask, C, isVertical, fit)
    nBins = 2;
    W = 9;    
    [eqMeans, ~, eqVals] = sliceStats(signal, mask, C, W, isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [~,~,err,errSem,~] = crossValidationRegression(fit,distances,eqMeans,nBins);
end