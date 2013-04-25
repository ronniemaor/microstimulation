%% time series of stim/blank for whole chamber 
figure;
range = 20:50;
signal = mean(relativeSignal(blank,stims,range),3);
dynamicRange = 2e-3;
mimg(signal,100,100,-dynamicRange,dynamicRange,range); colormap(mapgeog);
