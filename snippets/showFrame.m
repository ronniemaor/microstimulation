function showFrame(data, dynamicRange, frameToShow)
    if nargin < 2
        dynamicRange = 2e-3;
    end
    if nargin < 3
        data = findPeak(data);
        frameToShow = data.peakFrame;
    end
    signal = relativeSignal(data.blank,data.stims,frameToShow);
    signal = mean(signal,3);
    figure;
    mimg(signal,100,100,-dynamicRange,dynamicRange,frameToShow); 
    colormap(mapgeog);
    impixelinfo;
end