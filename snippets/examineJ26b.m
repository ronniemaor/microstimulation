function examineJ26b(data,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    W = take_from_struct(parms,'W',9);
    frames = take_from_struct(parms, 'frames', 25:30);
    threshold = 2.5E-4;

    data = findPeak(data);
    
    nCols = length(frames);
    nRows = 2;
    myfigure;
    for isVertical = [0 1]
        for iFrame = 1:length(frames)
            iPlot = iFrame + isVertical*length(frames);
            frame = frames(iFrame);
            subplot(nRows,nCols,iPlot);
            signal = data.signal(:,frame,:);
            ttl = sprintf('Frame %d',frame);
            drawOneFit(data.mask, signal, data.C, W, isVertical, add_parms(parms,'ttl',ttl,'threshold',threshold))
        end
    end
end
