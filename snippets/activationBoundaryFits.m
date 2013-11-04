function [speeds,frameRange,boundaries] = activationBoundaryFits(sessionKey,isVertical,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    parms.fit = take_from_struct(parms,'fit',GaussianFit);
    frameRange = take_from_struct(parms,'frameRange',20:50);
    thresholds = take_from_struct(parms,'thresholds', 1E-3 * [0.25 0.5 0.75 1]);
    minPointsForFit = take_from_struct(parms,'minPointsForFit', 3);
    minFrameForFit = take_from_struct(parms,'minFrameForFit', 25);
    maxFrameForFit = take_from_struct(parms,'maxFrameForFit', 36);
    showLegend = take_from_struct(parms,'showLegend',1);
    showParamsInTitle = take_from_struct(parms,'showParamsInTitle',1);
    onlyShowFittedPoints = take_from_struct(parms, 'onlyShowFittedPoints', 0);
    bPlot = take_from_struct(parms,'bPlot',true);

    P = cacheTimeCourseParams(sessionKey, parms);
    fitSlice = P.(sliceName(isVertical));
    
    nThresholds = length(thresholds);
    nFrames = length(frameRange);
    boundaries = zeros(nThresholds,nFrames);
    for iFrame = 1:nFrames
        frame = frameRange(iFrame);
        framePos = find(fitSlice.goodFrames == frame, 1);
        if framePos
            boundaries(:,iFrame) = parms.fit.fitArgs(thresholds,fitSlice.P(:,framePos));
        else
            boundaries(:,iFrame) = NaN;
        end
    end

    speeds = zeros(1,nThresholds);
    linearFits = cell(2,nThresholds);
    for iThreshold = 1:nThresholds
        framesForFitIdx = frameRange >= minFrameForFit & frameRange <= maxFrameForFit;
        framesForFit = frameRange(framesForFitIdx);
        distances = boundaries(iThreshold,framesForFitIdx)';
        [~,maxPos] = max(distances);
        distances = distances(1:maxPos);
        idx = ~isnan(distances);
        distances = distances(idx);
        frames = framesForFit(idx)';
        
        n = length(frames);
        
        if n < minPointsForFit
            speeds(iThreshold) = NaN;
            linearFits{1,iThreshold} = NaN;
            linearFits{2,iThreshold} = NaN;
        else        
            w = [frames ones(n,1)] \ distances;        
            speeds(iThreshold) = 10*w(1); % in cm/s (distances are in mm, frames are 10 msec)     
            linearFits{1,iThreshold} = w(1)*frames + w(2);
            linearFits{2,iThreshold} = frames;
        end
    end    
    
    config = getSessionConfig(sessionKey);
    frameZero = 25;
    msecPerFrame = 10;
    stimulationEnd = frameZero + config.trainDuration / msecPerFrame;
    
    if ~bPlot
        return
    end
    
    myfigure(parms);
    colors = jet;
    for iThreshold = 1:nThresholds
        x = boundaries(iThreshold,:);
        y = frameRange;
        idx = ~isnan(x);
        if onlyShowFittedPoints
            idx = idx & frameRange<=maxFrameForFit;
        end
        c = 1+floor(63*iThreshold/nThresholds);
        plot(x(idx),y(idx),'LineWidth',2,'Color',colors(c,:));
        hold all
    end
    for iThreshold = 1:nThresholds
        plot(linearFits{1,iThreshold}, linearFits{2,iThreshold},'--k')
    end
    maxBoundary = max(boundaries(:));
    plot([0 maxBoundary],[stimulationEnd stimulationEnd],'--r')
    
    t = sprintf('%s - %s',sessionKey,sliceName(isVertical));
    if showParamsInTitle
        t = sprintf('%s (%s)',t,formatStimulationParams(sessionKey));
    elseif ~showLegend && nThresholds == 1
        t = sprintf('%s (%.2g cm/s)',t,speeds(1));
    end
    title(t);
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    if ~isnan(maxBoundary)
        xlim([0 maxBoundary]);
        if onlyShowFittedPoints
            ylim([minFrameForFit maxFrameForFit])
        else
            yvals = [fitSlice.goodFrames stimulationEnd];
            ylim([min(yvals)-0.5 max(yvals)+0.5]);
        end
        if showLegend
            fLegend = @(idx) formatLegend(thresholds,speeds,idx);
            strLegend = arrayfun(fLegend, 1:nThresholds, 'UniformOutput', false);
            legend(strLegend, 'Location','NorthEastOutside');
        end
    end
end

function s = formatLegend(thresholds, speeds, idx)
    s1 = sprintf('\\Deltaf/f=%gE-4%s',thresholds(idx)*1E4);
    speed = speeds(idx);
    if isnan(speed)
        s2 = ', speed=N/A';
    else
        s2 = sprintf(', speed=%.2g cm/s', speed);
    end
    s = [s1 s2];
end