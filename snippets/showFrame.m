function showFrame(data, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    dynamicRange = take_from_struct(parms,'dynamicRange',2e-3);
    showCenter = take_from_struct(parms,'showCenter',1);
    showManualMask = take_from_struct(parms,'showManualMask',1);
    extraMaskedRegion = take_from_struct(parms,'extraMask',[]);
    
    frameToShow = take_from_struct(parms, 'frame', 0);
    if frameToShow == 0
        data = findPeak(data);
        frameToShow = data.peakFrame;
    end
% dynamicRange, frameToShow, showCenter, showManualMask, extraMaskedRegion
    
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
    
    myfigure;
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


