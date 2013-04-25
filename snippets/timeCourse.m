function timeCourse(blank, stims, C, frameRange, isVertical, fit, specialFrames)
    W = 9;
    nBins = 2;
    mask = chamberMask(blank);
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    nPlots = nParams + 1 + length(specialFrames);
    nCols = max(3,ceil(sqrt(nPlots)));
    nRows = ceil(nPlots/nCols);

    [P, err, errSem, ~] = fitsOverTime(fit, blank, stims, ...
                                       frameRange, W, C, ...
                                       isVertical, nBins);

    figure
    for iParam = 1:nParams
        subplot(nRows,nCols,iParam)
        plot(frameRange,P(iParam,:))
        name = paramNames{iParam};
        title(['Parameter ', name])
        ylabel(name)
        xlabel('Frame')
    end

    subplot(nRows,nCols,nParams+1);
    plot(frameRange, err)
    errorbar(frameRange, err, errSem);
    title('R2')
    ylabel('R2')
    xlabel('Frame')

    for iSpecial = 1:length(specialFrames)
        iPlot = nParams + 1 + iSpecial;
        frame = specialFrames(iSpecial)
        subplot(nRows,nCols,iPlot);
        signal = relativeSignal(blank,stims,frame);
        strTitle = sprintf('Frame %d',frame);
        drawOneFit(mask,signal,C,W,isVertical,fit,strTitle)
    end
    
    if isVertical; strAxis='vertical'; else strAxis='horizontal'; end;
    t = sprintf('%s parameters for %s slice, frames %d:%d W=%d, C=(%d,%d)', ...
                fit.name(), strAxis, min(frameRange), max(frameRange), ...
                W, C(1), C(2));
    topLevelTitle(t);
end
