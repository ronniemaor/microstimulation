function [means,eqVals] = mfEqMeans(frames,Eq)
% Uses Eq as a map of equivalence groups (e.g. equidistant rings around 
% a center point) and computes for each frame the mean of the values for
% all pixels per equivalence group.
%
% frames should be 2 dimensional array Pixels*Frames
% means is 2 dimensional Groups*Frames
% eqVals are the values used for equivalence groups (taken from Eq)

maxEq = max(Eq);
minEq = min(Eq);
eqVals = minEq:maxEq;

nFrames = size(frames,2);
means = NaN*zeros(length(eqVals),nFrames);

for iFrame = 1:nFrames
    F = frames(:,iFrame);
    for i = 1:length(eqVals)
        v = eqVals(i);
        means(i,iFrame) = mean(F(Eq==v));
    end
end