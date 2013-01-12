%% time series of stim/blank for whole chamber 
figure;
range = 20:80;
blank = mean(condsn(:,range,[4,5,6]),3);
stim = mean(condsn(:,range,[1,2,3]),3);
normalized = stim ./ blank -1;
mimg(normalized,100,100,-1e-3,1e-3,range); colormap(mapgeog);
