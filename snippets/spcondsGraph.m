%% time course per region: stim vs. blank
range = 10:100;
stimRange = nanmean(stims(:,range,:),3);
blankRange = blank(:,range);
plotdata = stimRange ./ blankRange - 1;
%plotdata(:,:,2) = blankRange;
plotspconds(plotdata,100,100,15);

%%

timeFrame = 20:80;
trials = 0 + (1:5);
signal = relativeSignal(blank,stims,timeFrame);
data = signal(:,:,trials);
plotspconds(data,100,100,10);