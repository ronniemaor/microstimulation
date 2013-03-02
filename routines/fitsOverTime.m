function [P,R2] = fitsOverTime(fit, blank, stims, ...
                               frameRange, W, C, vertical, nBins)
mask = chamberMask(blank);

nFrames = length(frameRange);
nParams = length(fit.paramNames());
P = zeros(nParams,nFrames);
R2 = zeros(1,nFrames);

for i = 1:nFrames
    signal = relativeSignal(blank,stims,frameRange(i));
    [eqMeans, ~, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [~,frameP,frameR2] = ...
                crossValidationRegression(fit,distances,eqMeans,nBins);
    P(:,i) = frameP';
    R2(i) = frameR2;
end
