function activationBoundaryFits(data,frameRange,isVertical,thresholds)
    fit = GaussianFit;
    if ~exist('thresholds','var')
        thresholds = 1E-3 * [0.25 0.5 0.75 1];
    end

    data = findPeak(data);
    
    nThresholds = length(thresholds);
    nFrames = length(frameRange);
    boundaries = zeros(nThresholds,nFrames);
    for iFrame = 1:nFrames
        frame = frameRange(iFrame);
        P = calcFit(fit, data, frame, isVertical);
        if isnan(P)
            boundaries(:,iFrame) = NaN;
        else
            boundaries(:,iFrame) = fit.fitArgs(thresholds,P);
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
    
    title(sprintf('%s - %s',data.sessionKey,sliceName(isVertical)))
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    xlim([0 max(boundaries(:))]);
    ylim([min(frameRange)-0.5 max(frameRange)+0.5]);
    fLegend = @(idx) sprintf('\\Deltaf/f=%gE-4, speed=%.2g cm/s',thresholds(idx)*1E4, speeds(idx));
    strLegend = arrayfun(fLegend, 1:nThresholds, 'UniformOutput', false);
    legend(strLegend, 'Location','NorthEastOutside');
    
    figure
    plot(thresholds*1E4,speeds);
    title('Speed as function of activation level used')
    xlabel('Activation level (\Deltaf/f x 1E-4)')
    ylabel('Speed (cm/s)')
end

function P = calcFit(fit, data, frame, isVertical)
    W = 9;
    nBins = 2;
    mmPerPixel = 0.1;
    signal = relativeSignal(data.blank, data.stims,frame);
    [eqMeans, ~, eqVals] = sliceStats(signal,data.mask,data.C,W,isVertical);
    distances = eqVals * mmPerPixel; % convert to mm    
    [yFit,P,R2] = crossValidationRegression(fit,distances,eqMeans,nBins);
%     plot(distances,yFit);
%     title(sprintf('frame %d',frame))
%     pause
    
    R2_threshold = 0.6; % don't use points below this threshold
    sigma_threshold = 10; % don't use points above this sigma (Gaussian fit only)
    
    paramNames = fit.paramNames();
    assert(strcmpi(paramNames{2},'sigma'),'Only GuassianFit is supported ATM');
    sigma = P(2);
    
    if R2 < R2_threshold || sigma > sigma_threshold
        P = NaN;
    end    
end
