function showFrame(data, dynamicRange, frameToShow, showCenter)
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
    
    signal = relativeSignal(data.blank,data.stims,frameToShow);
    signal = mean(signal,3); % mean across trials
    
    if showCenter
        region = getCenterPixels(data);
        signal(region) = -dynamicRange;
    end
    
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
    region = [xyToPixel(cX,cY), xyToPixel(cX-1,cY), xyToPixel(cX+1,cY), xyToPixel(cX,cY-1), xyToPixel(cX,cY+1)];
end

function pixel = xyToPixel(x,y)
    pixel = x + 100*(y-1);
end