function showFrame(data, dynamicRange, frameToShow, showCenter, showManualMask, extraMaskedRegion)
    if nargin < 2
        dynamicRange = 2e-3;
    end
    if nargin < 3
        data = findPeak(data);
        frameToShow = data.peakFrame;
    end
    if nargin < 4
        showCenter = 1;
    end
    if nargin < 5
        showManualMask = 1;
    end
    if nargin < 6
        extraMaskedRegion = [];
    end
    
    signal = data.signal(:,frameToShow,:);
    signal = mean(signal,3); % mean across trials
    
    if showCenter
        region = getCenterPixels(data);
        signal(region) = -dynamicRange;
    end
    
    if showManualMask
        region = data.origMask & ~data.mask;
        signal(region) = -dynamicRange;
    end
    
    signal(extraMaskedRegion) = -dynamicRange;
    
    figure;
    mimg(signal,100,100,-dynamicRange,dynamicRange,' '); 
    colormap(mapgeog);
    topLevelTitle(sprintf('%s - frame %d', data.sessionKey, frameToShow));
    impixelinfo;
end

function region = getCenterPixels(data)
    data = findPeak(data);
    cX = data.C(1);
    cY = data.C(2);
    f = @(x,y) sub2ind([100 100],x,y);
    region = [f(cX,cY), f(cX-1,cY), f(cX+1,cY), f(cX,cY-1), f(cX,cY+1)];
end


