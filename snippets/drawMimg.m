%% time series of stim/blank for whole chamber 
function drawMimg(data, dynamicRange, frameRange)
    if nargin < 2
        dynamicRange = 2e-3;
    end
    if nargin < 3
        frameRange = 20:50;
    end
    
    signal = relativeSignal(data.blank, data.stims, frameRange);
    meanSignal = mean(signal,3);
    
    figure;
    mimg(meanSignal,100,100,-dynamicRange,dynamicRange,frameRange); 
    colormap(mapgeog);
end