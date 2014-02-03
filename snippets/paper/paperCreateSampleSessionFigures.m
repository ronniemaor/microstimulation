function paperCreateSampleSessionFigures(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    fontSize = 16;
    fit = GaussianFit;

    R2_threshold = 0.6;    

    data = findPeak(data);
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    nRows = 2;
    nCols = nParams + 1;

    maxVals = NaN*zeros(1,nParams);
    minVals = NaN*zeros(1,nParams);
    maxFrame = NaN;
    minFrame = NaN;
    
    myfigure(parms);
    for isVertical = 0:1
        P = cacheTimeCourseParams(data.sessionKey, parms);        
        sliceStruct = P.(sliceName(isVertical));
        
        frames = sliceStruct.goodFrames;
        maxFrame = max(max(frames),maxFrame);
        minFrame = min(min(frames),minFrame);
        
        for iParam = 1:nParams
            name = paramNames{iParam};
            vals = sliceStruct.(name);
            maxVals(iParam) = max(max(vals),maxVals(iParam));
            minVals(iParam) = min(min(vals),minVals(iParam));
            times = 10 * (frames - 25);

            if strcmpi(name,'sigma')
                name = 'Width';
            end
            if strcmpi(name,'a')
                name = 'Amplitude';
            end

            subplot(nRows,nCols,nCols*isVertical+iParam)
            set(gca,'FontSize',fontSize)            
            plot(times,vals, 'LineWidth', 2, 'Marker','o', 'MarkerSize', 3)
            if iParam == 1
                t = sprintf('%s - %s',sliceName(isVertical),name);
            else
                t = name;
            end
            title(t)
            ylabel(name)
            xlabel('Time from stimulus [msec]')
        end

        subplot(nRows,nCols,nCols*(isVertical+1))
        set(gca,'FontSize',fontSize)        
        times = frameToTime(P.frameRange);
        vals = sliceStruct.R2;
        plot(times, vals, 'LineWidth', 2)
        hold on
        plot([min(times) max(times)], [R2_threshold R2_threshold], 'r--');
        ylim([0 1]);
        title('Goodness of fit')
        ylabel('R2')
        xlabel('Time from stimulus [msec]')        
    end
    
    % adjust x,y limits
    for xPlot = 1:nParams % don't adjust R2
        for isVertical = 0:1
            iPlot = nCols*isVertical + xPlot;
            subplot(nRows,nCols,iPlot);
            ylim([minVals(xPlot) maxVals(xPlot)]);
            xlim(frameToTime([minFrame maxFrame]))
        end
    end    
    
    topLevelTitle(sprintf('%s - fit behavior over time', data.sessionKey));    
end

function times = frameToTime(frames)
    times = 10 * (frames - 25);
end