%% signal levels over chamber at peak frame
chosenFrame = 26; % peakFrame
signal = relativeSignal(blank,stims,chosenFrame);
signal = mean(signal,3);
figure;
dynamicRange = 2e-3;
mimg(signal,100,100,-dynamicRange,dynamicRange,chosenFrame); 
colormap(mapgeog);
impixelinfo;
