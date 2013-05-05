%% time series of stim/blank for whole chamber 
function drawMimg(data, dynamicRange, frameRange, bNormalizeTime)
    if nargin < 2
        dynamicRange = 2e-3;
    end
    if nargin < 3
        frameRange = 20:50;
    end
    if nargin < 4
        bNormalizeTime = 0;
    end
    
    signal = relativeSignal(data.blank, data.stims, frameRange);
    meanSignal = mean(signal,3);
    if bNormalizeTime
        startFrame = 25;
        msecPerFrame = 10;
        times = msecPerFrame * (frameRange - startFrame);
    else
        times = frameRange;
    end
    
    figure;
    mimg(meanSignal,100,100,-dynamicRange,dynamicRange,times,0,16); 
    colormap(mapgeog);
end