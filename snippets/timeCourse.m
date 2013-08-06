function timeCourse(data, isVertical, frameRange, fit, specialFrames)
    if nargin < 5
        specialFrames = [];
    end
    
    W = 9;
    nBins = 2;
    R2_threshold = 0.6; % don't use points below this threshold
    sigma_threshold = 10; % don't use points above this sigma (Gaussian fit only)    
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    nPlots = nParams + 1 + length(specialFrames);
    nCols = max(3,ceil(sqrt(nPlots)));
    nRows = ceil(nPlots/nCols);

    data = findPeak(data);
    [P, err, errSem, ~] = fitsOverTime(fit, ... 
                                       data.blank, data.stims, data.mask, ...
                                       frameRange, W, data.C, ...
                                       isVertical, nBins);
                                   
    highR2 = err > R2_threshold;
    goodPositions = highR2; % can't trust fits with R2 below this threshold
    for iParam = 1:nParams
        if strcmpi(paramNames{iParam},'sigma')
            smallSigma = P(iParam,:) < sigma_threshold;
            goodPositions = goodPositions & smallSigma;
        end
    end                                   

    figure
    
    % plot a figure for each parameter
    for iParam = 1:nParams
        subplot(nRows,nCols,iParam)
        name = paramNames{iParam};        
        goodFrames = frameRange(goodPositions);
        goodP = P(iParam,goodPositions);        
        plot(goodFrames,goodP)
        xlim([min(frameRange) max(frameRange)])
        title(['Parameter ', name])
        ylabel(name)
        xlabel('Frame')
    end

    % plot the figure for R2
    subplot(nRows,nCols,nParams+1);
    errorbar(frameRange, err, errSem);
    xlim([min(frameRange) max(frameRange)])
    title('R2')
    ylabel('R2')
    xlabel('Frame')

    % plot the fits for the "special frames"
    for iSpecial = 1:length(specialFrames)
        iPlot = nParams + 1 + iSpecial;
        frame = specialFrames(iSpecial);
        subplot(nRows,nCols,iPlot);
        signal = relativeSignal(data.blank, data.stims,frame);
        strTitle = sprintf('Frame %d',frame);
        drawOneFit(data.mask,signal,data.C,W,isVertical,fit,strTitle)
    end
    
    t = sprintf('%s - %s parameters for %s slice, frames %d:%d W=%d, C=(%d,%d)', ...
                data.sessionKey, fit.name(), sliceName(isVertical,1), min(frameRange), max(frameRange), ...
                W, data.C(1), data.C(2));
    topLevelTitle(t);
end
