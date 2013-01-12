%% time course per region: all conditions
figure; 
plotspconds(condsn(:,2:230,1:6),100,100,5);

%% time course per region: stim vs. blank
range = 2:230;
stim = nanmean(condsn(:,range,1:3),3);
blank = nanmean(condsn(:,range,4:6),3);
plotdata = stim;
plotdata(:,:,2) = blank;
plotspconds(plotdata,100,100,5);
