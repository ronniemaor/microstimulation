function activationBoundaryFits(sessionKey,isVertical,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    parms.fit = take_from_struct(parms,'fit',GaussianFit);
    frameRange = take_from_struct(parms,'frameRange',20:50);
    thresholds = take_from_struct(parms,'thresholds', 1E-3 * [0.25 0.5 0.75 1]);

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
        distances = boundaries(iThreshold,:)';
        [~,maxPos] = max(distances);
        distances = distances(1:maxPos);
        idx = ~isnan(distances);
        distances = distances(idx);
        frames = frameRange(idx)';
        
        n = length(frames);
        w = [frames ones(n,1)] \ distances;
        
        speeds(iThreshold) = 10*w(1); % in cm/s (distances are in mm, frames are 10 msec)     
        linearFits{1,iThreshold} = w(1)*frames + w(2);
        linearFits{2,iThreshold} = frames;
    end    
    
    myfigure(parms);
    colors = jet;
    for iThreshold = 1:nThresholds
        x = boundaries(iThreshold,:);
        y = frameRange;
        idx = ~isnan(x);
        c = 1+floor(63*iThreshold/nThresholds);
        plot(x(idx),y(idx),'LineWidth',2,'Color',colors(c,:));
        hold all
    end
    for iThreshold = 1:nThresholds
        plot(linearFits{1,iThreshold}, linearFits{2,iThreshold},'--k')
    end
    
    title(sprintf('%s - %s',sessionKey,sliceName(isVertical)))
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    xlim([0 max(boundaries(:))]);
    ylim([min(fitSlice.goodFrames)-0.5 max(fitSlice.goodFrames)+0.5]);
    fLegend = @(idx) sprintf('\\Deltaf/f=%gE-4, speed=%.2g cm/s',thresholds(idx)*1E4, speeds(idx));
    strLegend = arrayfun(fLegend, 1:nThresholds, 'UniformOutput', false);
    legend(strLegend, 'Location','NorthEastOutside');
    
%     figure
%     plot(thresholds*1E4,speeds);
%     title('Speed as function of activation level used')
%     xlabel('Activation level (\Deltaf/f x 1E-4)')
%     ylabel('Speed (cm/s)')
end

