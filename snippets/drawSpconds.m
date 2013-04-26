%% time course per region: stim vs. blank
function drawSpconds(data, nBins, frameRange)
    if nargin < 2
        nBins = 10;
    end
    if nargin < 3
        frameRange = 10:80;
    end
    stimRange = nanmean(data.stims(:,frameRange,:),3);
    blankRange = data.blank(:,frameRange);
    plotdata = stimRange ./ blankRange - 1;
    plotspconds(plotdata,100,100,nBins);
end
