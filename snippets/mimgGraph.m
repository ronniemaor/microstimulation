%% time series of stim/blank for whole chamber 
figure;
range = 25:40;
signal = relativeSignal(condsn,range);
mimg(signal,100,100,-1e-3,1e-3,range); colormap(mapgeog);
