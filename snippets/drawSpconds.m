%% time course per region: stim vs. blank
function drawSpconds(data, nBins, frameRange, showOrig)
    if nargin < 2
        nBins = 10;
    end
    if nargin < 3
        frameRange = 10:80;
    end
    if nargin < 4
        showOrig = true;
    end
    plotdata = mean(data.signal(:,frameRange,:),3);
    if showOrig
        plotdata(:,:,2) = mean(data.orig_signal(:,frameRange,:),3);
    end
    figure;
    plotspconds(plotdata,100,100,nBins);
end
