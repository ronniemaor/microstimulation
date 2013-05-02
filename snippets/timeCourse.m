function timeCourse(data, isVertical, frameRange, fit, specialFrames)
    if nargin < 5
        specialFrames = [];
    end
    
    W = 9;
    nBins = 2;
        
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

    figure
    for iParam = 1:nParams
        subplot(nRows,nCols,iParam)
        name = paramNames{iParam};
        paramVals = P(iParam,:);
        if strcmpi(name,'sigma')
            paramVals(paramVals > 10) = NaN;
        end
        plot(frameRange,paramVals)
        title(['Parameter ', name])
        ylabel(name)
        xlabel('Frame')
    end

    subplot(nRows,nCols,nParams+1);
    errorbar(frameRange, err, errSem);
    title('R2')
    ylabel('R2')
    xlabel('Frame')

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
