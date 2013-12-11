function [P, err, errSem, overfitR2] = fitsOverTime(... 
                               fit, signal, mask, ...
                               frameRange, W, C, vertical, nBins)
nFrames = length(frameRange);
err = zeros(1,nFrames);
errSem = zeros(1,nFrames);
overfitR2 = zeros(1,nFrames);

for i = 1:nFrames
    frameSignal = signal(:,frameRange(i),:);
    [eqMeans, ~, eqVals] = sliceStats(frameSignal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    [~, frameP, frameErr, frameErrSem, frameOverfitR2] = ...
                crossValidationRegression(fit,distances,eqMeans,nBins);
    P(:,i) = frameP';
    err(i) = frameErr;
    errSem(i) = frameErrSem;
    overfitR2(i) = frameOverfitR2;
end
