%% 3D plot: time*distance -> signal
function drawSignalOverSliceAndTime(data, isVertical, frameRange)
    if nargin < 3
        frameRange = 2:80;
    end
    data = findPeak(data);
    signal = relativeSignal(data.blank,data.stims,frameRange);
    W = 9;
    [means,eqVals] = sliceTransform(signal,data.mask,data.C,W,isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    msecPerFrame = 10;
    times = (frameRange-25)*msecPerFrame; % convert to msec from onset
    
    figure; 
    surf(times,distances,means); 
    colorbar;
    view(0,90);
    if isVertical; strAxis='vertical'; else strAxis='horizontal'; end;
    title(sprintf('Signal strength for time and %s distance',strAxis));
    xlabel('Time from stimulus onset (msec)'); 
    ylabel('Distance from peak (mm)'); 
    zlabel('Relative signal');
end