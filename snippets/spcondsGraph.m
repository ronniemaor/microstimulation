%% time course per region: stim vs. blank
range = 2:230;
stimRange = nanmean(stims(:,range,:),3);
blankRange = blank(:,range);
plotdata = stimRange;
plotdata(:,:,2) = blankRange;
plotspconds(plotdata,100,100,5);

%%

timeFrame = 20:80;
signal = relativeSignal(blank,stims,timeFrame);
%data = mean(signal(:,:,20:29),3);
data = signal(:,:,20:29);
plotspconds(data,100,100,10);