function activationBoundary(data)
    frameRange = 25:50;
    isVertical = 0;

    data = findPeak(data);
    signal = relativeSignal(data.blank, data.stims, 1:80);
        
    thresholds = 1E-3 * [0 0.25 0.5 0.75 1];
    nBins = length(thresholds);

    figure;
    colors = jet;
    for iFrame = 1:length(frameRange)
        frame = frameRange(iFrame);
        [distances,responses] = calcSlice(data, frame, isVertical);
        
        binned = zeros(size(responses));
        for iBin=1:nBins
            binned = binned + (responses > thresholds(iBin));
        end
        
        for i=0:nBins
            x = distances(binned == i);
            y = frame*ones(size(x));
            c = 1+floor(63*i/nBins);
            plot(x,y,'o','MarkerFaceColor',colors(c,:));
            hold on;
        end
    end
    title(sprintf('%s - %s',data.sessionKey,sliceName(isVertical)))
    xlabel('distance from peak [mm]')
    ylabel('frame number')
    xlim([0 max(distances)]);
    ylim([min(frameRange)-0.5 max(frameRange)+0.5]);
end

function [distances, responses] = calcSlice(data, frame, isVertical)
    W = 9;
    mmPerPixel = 0.1;
    signal = relativeSignal(data.blank, data.stims,frame);
    [eqMeans, ~, eqVals] = sliceStats(signal,data.mask,data.C,W,isVertical);
    distances = eqVals * mmPerPixel; % convert to mm
    responses = mean(eqMeans,1); % average over trials
end
