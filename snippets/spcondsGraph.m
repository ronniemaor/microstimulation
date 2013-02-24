%% time course per region: stim vs. blank
range = 2:230;
stimRange = nanmean(stims(:,range,:),3);
blankRange = blank(:,range);
plotdata = stimRange;
plotdata(:,:,2) = blankRange;
plotspconds(plotdata,100,100,5);
