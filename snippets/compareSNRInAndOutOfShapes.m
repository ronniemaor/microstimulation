function [signalRegionSNR, weightEstimationRegionSNR] = compareSNRInAndOutOfShapes(data, parms)
    if ~exist('parms', 'var')
        parms = make_parms();
    end
    
    showMasks = take_from_struct(parms,'showMasks',false);
    bDrawBars = take_from_struct(parms,'draw',false);
    
    data = findPeak(data);
    shape = createPCAWeightingShape(data, parms);
    
    weightEstimationRegion = data.origMask & shape;
    signalRegion = data.mask & ~shape;
    
    % sample pixels from larger region to make it same size as the smaller one
    nPixels = min(sum(weightEstimationRegion),sum(signalRegion));
    weightEstimationRegion = samplePixels(weightEstimationRegion,nPixels);
    signalRegion = samplePixels(signalRegion,nPixels);
    
    if showMasks
        showFrame(data,make_parms('showManualMask',0,'extraMask',weightEstimationRegion))
        showFrame(data,make_parms('showManualMask',0,'extraMask',signalRegion))
    end
    
    weightEstimationRegionSNR = calcSNR(data,weightEstimationRegion);
    signalRegionSNR = calcSNR(data,signalRegion);
    
    if bDrawBars
        myfigure(parms);
        bar([signalRegionSNR, weightEstimationRegionSNR])
        set(gca,'XTickLabel',{'signal region', 'weight estimation region'})
        ylabel('d'' between peak and baseline frames')
        title('Signal change in "Signal" vs. "Weight estimation" regions')
    end
end

function new_mask = samplePixels(mask,nPixels)
    rng(0);
    pixels = find(mask == 1);
    inds = randperm(length(pixels),nPixels);
    pixels = pixels(inds);
    new_mask = zeros(10000,1);
    new_mask(pixels) = 1;
    new_mask = logical(new_mask);
end

function dprime = calcSNR(data, region)
    signalFrames = (data.peakFrame-2):(data.peakFrame+2);
    baseFrames = 11:15;
    [muSignal,sigmaSignal] = calcDistributionOverFrames(data.orig_signal(region,signalFrames,:));
    [muBase,sigmaBase] = calcDistributionOverFrames(data.orig_signal(region,baseFrames,:));
    dprime = (muSignal-muBase) / sqrt((sigmaSignal^2 + sigmaBase^2)/2);
end

function [mu,sigma] = calcDistributionOverFrames(signal)
    signal = mean(signal,3); % average over trials
    signal = squeeze(mean(signal,1)); % average over pixels
    mu = mean(signal);
    sigma = std(signal);
end