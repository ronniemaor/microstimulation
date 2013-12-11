% movie of how signal(distance) curve changes over time
function spatialResponseOverTimeMovie(data, isVertical, frameRange)
    data = findPeak(data);
    W = 9;
    nFrames = length(frameRange);

    writerObj = VideoWriter('response','MPEG-4');
    writerObj.open()
    for iFrame = 1:nFrames
        frameNumber = frameRange(iFrame);
        signal = data.signal(:,frameNumber,:);
        [eqMeans, eqStd, eqVals] = ...
            sliceStats(signal, data.mask, data.C, W, isVertical);
        mmPerPixel = 0.1;
        distances = eqVals * mmPerPixel; % convert to mm
        eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials    
        errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
        title(sprintf('Frame %d',frameNumber))
        frame = getframe;
        for iDup = 1:10 % duplicate frames to slow things down (worked better than setting very slow frame rate)
            writerObj.writeVideo(frame);
        end
    end
    writerObj.close()
end