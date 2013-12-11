%% time course per region: stim vs. blank
function drawSpconds(data, nBins, frameRange)
    if nargin < 2
        nBins = 10;
    end
    if nargin < 3
        frameRange = 10:80;
    end
    signal = data.signal(:,frameRange,:);
    plotdata = mean(signal,3);
    plotspconds(plotdata,100,100,nBins);
end
