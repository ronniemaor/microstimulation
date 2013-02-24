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
    [frame_a, frame_mu, frame_sigma, frame_R2] = ...
        bestGaussian(distances,eqMeans);
    a(i) = frame_a;
    mu(i) = frame_mu;
    sigma(i) = frame_sigma;
    R2(i) = frame_R2;
end
