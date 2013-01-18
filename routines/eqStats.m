function [eqMeans, eqStd, eqVals] = eqStats(frames,Eq)
% Uses Eq as a map of equivalence groups (e.g. equidistant rings around 
% a center point) and compute mean,std for all points belonging to the 
% equivalence group (over all frames).
%
% frames should be 2 dimensional array Pixels*Frames
% eqMeans is 1*Groups array of mean(group)
% eqStd is 1*Groups array of std(group)
% eqVals are the values used for equivalence groups (taken from Eq)

maxEq = max(Eq);
minEq = min(Eq);
eqVals = minEq:maxEq;

nFrames = size(frames,2);
eqMeans = NaN*zeros(1,length(eqVals));
eqStd = NaN*zeros(1,length(eqVals));

for i = 1:length(eqVals)
    v = eqVals(i);
    groupIdx = Eq==v;
    nPoints = 0;
    sumVals = 0;
    sumSquares = 0;
    for iFrame = 1:nFrames
        F = frames(:,iFrame);
        frameVals = F(groupIdx);
        nPoints = nPoints + length(frameVals);
        sumVals = sumVals + sum(frameVals);
        sumSquares = sumSquares + sum(frameVals .^ 2);
    end
    mean = sumVals/nPoints;
    meanSquares = sumSquares/nPoints;
    sigma = sqrt(meanSquares - mean^2);
    eqMeans(i) = mean;
    eqStd(i) = sigma;
end