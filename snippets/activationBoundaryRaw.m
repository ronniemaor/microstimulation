function activationBoundaryRaw(data,isVertical,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    frameRange = take_from_struct(parms,'frames', 20:50);
    thresholds = take_from_struct(parms,'thresholds', 1E-3 * [0.25 0.5 0.75 1]);

    data = findPeak(data);
        
    nThresholds = length(thresholds);
    nFrames = length(frameRange);
    
    boundaries = zeros(nThresholds,nFrames);
    dummyDistances = calcSlice(data, frameRange(1), isVertical);
    distanceResolution = 0.1; % mm per pixel
    nDistances = 1 + round(max(dummyDistances)/distanceResolution);
    binnedResponses = zeros(nFrames,nDistances);     

    for iFrame = 1:length(frameRange)
        frame = frameRange(iFrame);
        [distances,responses] = calcSlice(data, frame, isVertical);
        
        bins = zeros(size(responses));
        for iBin=1:nThresholds
            threshold = thresholds(iBin);
            isAbove = responses > threshold;
            bins = bins + isAbove;
            pos = 1 + round(distances(isAbove)/distanceResolution);
            binnedResponses(iFrame, pos) = threshold;
        end        

        for iBin=1:nThresholds
            x = distances(bins == iBin);
            x = x(~isnan(x));
            boundaries(iBin,iFrame) = median(x);
        end
    end
    
    myfigure(parms);
    imagesc(dummyDistances, frameRange, flipud(binnedResponses))
    set(gca,'YTickLabel',flipud(get(gca, 'YTickLabel')));
    title(sprintf('%s - %s',data.sessionKey,sliceName(isVertical)))
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    
    if take_from_struct(parms,'calcSpeeds',0)
        calcSpeeds(data, isVertical, frameRange, thresholds, boundaries)
    end
end

function [distances, responses] = calcSlice(data, frame, isVertical)
    W = 9;
    mmPerPixel = 0.1;
    signal = relativeSignal(data.blank, data.stims,frame);
    [eqMeans, ~, eqVals] = sliceStats(signal,data.mask,data.C,W,isVertical);
    distances = eqVals * mmPerPixel; % convert to mm
    responses = mean(eqMeans,1); % average over trials
end

function calcSpeeds(data, isVertical, frameRange, thresholds, boundaries)
    nThresholds = length(thresholds);
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
    
    figure;
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
    
    title(sprintf('Medians on raw data. %s - %s',data.sessionKey,sliceName(isVertical)))
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    xlim([0 max(boundaries(:))]);
    ylim([min(frameRange)-0.5 max(frameRange)+0.5]);
    fLegend = @(idx) sprintf('\\Deltaf/f=%gE-4, speed=%.2g cm/s',thresholds(idx)*1E4, speeds(idx));
    strLegend = arrayfun(fLegend, 1:nThresholds, 'UniformOutput', false);
    legend(strLegend, 'Location','NorthEastOutside');
end
