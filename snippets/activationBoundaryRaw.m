function activationBoundaryRaw(data,frameRange,isVertical,thresholds)
    if ~exist('thresholds','var')
        thresholds = 1E-3 * [0.25 0.5 0.75 1];
    end

    data = findPeak(data);
        
    nThresholds = length(thresholds);
    nFrames = length(frameRange);
    
    boundaries = zeros(nThresholds,nFrames);

    figure;
    colors = jet;
    for iFrame = 1:length(frameRange)
        frame = frameRange(iFrame);
        [distances,responses] = calcSlice(data, frame, isVertical);
        
        binned = zeros(size(responses));
        for iBin=1:nThresholds
            binned = binned + (responses > thresholds(iBin));
        end        

        for iBin=1:nThresholds
            x = distances(binned == iBin);
            x = x(~isnan(x));
            boundaries(iBin,iFrame) = median(x);
        end
        
        for i=0:nThresholds
            x = distances(binned == i);
            y = frame*ones(size(x));
            c = 1+floor(63*i/nThresholds);
            plot(x,y,'o','MarkerFaceColor',colors(c,:));
            hold on;
        end
    end
    title(sprintf('%s - %s',data.sessionKey,sliceName(isVertical)))
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    xlim([0 max(distances)]);
    ylim([min(frameRange)-0.5 max(frameRange)+0.5]);
    
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

function [distances, responses] = calcSlice(data, frame, isVertical)
    W = 9;
    mmPerPixel = 0.1;
    signal = relativeSignal(data.blank, data.stims,frame);
    [eqMeans, ~, eqVals] = sliceStats(signal,data.mask,data.C,W,isVertical);
    distances = eqVals * mmPerPixel; % convert to mm
    responses = mean(eqMeans,1); % average over trials
end
