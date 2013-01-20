function [a,b,mu,sigma,err] = fitsOverTime(conds, frameRange, W, C, vertical)
mask = chamberMask(conds);

nFrames = length(frameRange);
a = zeros(1,nFrames);
b = zeros(1,nFrames);
mu = zeros(1,nFrames);
sigma = zeros(1,nFrames);
err = zeros(1,nFrames);

for i = 1:nFrames
    signal = relativeSignal(conds,frameRange(i));
    [eqMeans, ~, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [frame_a, frame_b, frame_mu, frame_sigma, frame_err] = ...
        bestGaussian(distances,eqMeans);
    a(i) = frame_a;
    b(i) = frame_b;
    mu(i) = frame_mu;
    sigma(i) = frame_sigma;
    err(i) = frame_err;
end
