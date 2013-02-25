function [a,mu,sigma,R2] = fitsOverTime(blank, stims, ...
                                        frameRange, W, C, vertical)
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
    P = GaussianFit.fitParams(distances,eqMeans);
    a(i) = P(1);
    mu(i) = P(2);
    sigma(i) = P(3);
    fit = GaussianFit.fitValues(distances,P);
    R2(i) = calcR2(fit,eqMeans);
end
