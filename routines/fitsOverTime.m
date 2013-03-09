function [P, R2, R2sem, overfitR2] = fitsOverTime(fit, blank, stims, ...
                               frameRange, W, C, vertical, nBins)
mask = chamberMask(blank);

nFrames = length(frameRange);
nParams = length(fit.paramNames());
R2 = zeros(1,nFrames);
R2sem = zeros(1,nFrames);
overfitR2 = zeros(1,nFrames);

for i = 1:nFrames
    signal = relativeSignal(blank,stims,frameRange(i));
    [eqMeans, ~, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [~, frameP, frameR2, frameR2sem, frameOverfitR2] = ...
                crossValidationRegression(fit,distances,eqMeans,nBins);
    P(:,i) = frameP';
    R2(i) = frameR2;
    R2sem(i) = frameR2sem;
    overfitR2(i) = frameOverfitR2;
end
