function [a,mu,sigma,R2] = fitsOverTime(fit, blank, stims, ...
                                        frameRange, W, C, vertical, nBins)
mask = chamberMask(blank);

nFrames = length(frameRange);
a = zeros(1,nFrames);
mu = zeros(1,nFrames);
sigma = zeros(1,nFrames);
R2 = zeros(1,nFrames);

for i = 1:nFrames
    signal = relativeSignal(blank,stims,frameRange(i));
    [eqMeans, ~, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [~,P,frameR2] = crossValidationRegression(fit,distances,eqMeans,nBins);
    a(i) = P(1);
    mu(i) = P(2);
    sigma(i) = P(3);
    R2(i) = frameR2;
end
