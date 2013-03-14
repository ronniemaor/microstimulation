signal = relativeSignal(blank,stims,1:100);
[cX cY peakFrame] = findPeakActivity(signal);
C = [cX cY];
