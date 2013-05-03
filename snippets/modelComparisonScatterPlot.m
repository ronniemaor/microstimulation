function modelComparisonScatterPlot(fits, sessions)
    fitNames = cellfun(@(fit) fit.name(), fits, 'UniformOutput',false);
    nFits = length(fits);
    assert(nFits == 2, 'Model scatter comparison scatter plot should be called with exactly two fits')
    
    if nargin < 2
        allSessions = getAllSessionConfigs();
        sessions = allSessions.keys();
    end
    nSessions = length(sessions);
    nSlices = 2;

    err = zeros(nSessions, nSlices, nFits);

    iSession = 0;
    for cSession = sessions
        iSession = iSession + 1;
        sessionKey = cSession{1};
        data = loadData(sessionKey);
        data = findPeak(data);
        signal = relativeSignal(data.blank,data.stims,data.peakFrame);
        for iSlice = 1:2
            isVertical = iSlice == 2;
            for iFit = 1:nFits
                fit = fits{iFit};
                [thisErr, ~] = goodnessOfFit(signal, data.mask, data.C, isVertical, fit);
                err(iSession,iSlice,iFit) = thisErr;
            end
        end            
    end

    figure
    X = err(:,:,1);
    X = X(:);
    Y = err(:,:,2);
    Y = Y(:);
    scatter(X,Y);
    title('Model comparison across sessions');
    xlabel(sprintf('R2 for %s', fitNames{1}))
    ylabel(sprintf('R2 for %s', fitNames{2}))
    lim = [0 1];
    xlim(lim) 
    ylim(lim)
    hold on
    plot(lim,lim,'g')
end

function [err, errSem] = goodnessOfFit(signal, mask, C, isVertical, fit)
    nBins = 2;
    W = 9;    
    [eqMeans, ~, eqVals] = sliceStats(signal, mask, C, W, isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [~,~,err,errSem,~] = crossValidationRegression(fit,distances,eqMeans,nBins);
end