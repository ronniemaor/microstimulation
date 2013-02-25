%% time series of stim/blank for whole chamber 
figure;
range = 20:50;
signal = mean(relativeSignal(blank,stims,range),3);
mimg(signal,100,100,-1e-3,1e-3,range); colormap(mapgeog);
