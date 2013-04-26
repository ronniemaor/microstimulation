function data = findPeak(data)
    signal = relativeSignal(data.blank, data.stims, 1:80);
    [cX cY peakFrame] = findPeakActivity(signal);
    C = [cX cY];
    data.C = C;
    data.peakFrame = peakFrame;
end
