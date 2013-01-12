function [means,rVals] = mfRingMeans(frames,R)
% Uses R as a map of equivalence groups (e.g. equidistant rings around 
% a center point) and computes for each frame the mean of the values for
% all pixels per equivalence group.
%
% frames should be 2 dimensional array Pixels*Frames
% means is 2 dimensional Groups*Frames
% rVals are the values used for equivalence groups (taken from R)

maxR = max(R);
minR = min(R);
rVals = minR:maxR;

nFrames = size(frames,2);
means = NaN*zeros(length(rVals),nFrames);

for iFrame = 1:nFrames
    F = frames(:,iFrame);
    for i = 1:length(rVals)
        r = rVals(i);
        means(i,iFrame) = mean(F(R==r));
    end
end