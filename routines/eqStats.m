function [eqMeans, eqStd, eqVals] = eqStats(signal,Eq)
% Uses Eq as a map of equivalence groups (e.g. equidistant rings around 
% a center point) and compute mean and std for all points belonging to the 
% equivalence group. 
% The mean and std are computed over all frames for each trial.
%
% Input:
%   signal - Pixels*Frames*Trials
%   Eq - equivalence groups (row vector of size nPixels)
% Output:
%   eqMeans - nTrials*nGroups vector of mean(group) per trial
%   eqStd - nTrials*nGroups vector of std(group) per trial
%   eqVals - 1*nGroups vector of values used for equiv. groups (from Eq)

maxEq = max(Eq);
minEq = min(Eq);
eqVals = minEq:maxEq;
nGroups = length(eqVals);
nFrames = size(signal,2);
nTrials = size(signal,3);
eqMeans = NaN*zeros(nTrials,nGroups);
eqStd = NaN*zeros(nTrials,nGroups);
for iGroup = 1:nGroups
    v = eqVals(iGroup);
    groupIdx = Eq==v;
    groupVals = signal(groupIdx,:,:);
    groupSize = size(groupVals,1);
    % flatten pixels and frames to rows and leave trials as columns
    % then compute mean + std for all trials together (as columns)
    flatVals = reshape(groupVals, groupSize*nFrames, nTrials);
    eqMeans(:,iGroup) = mean(flatVals)';
    eqStd(:,iGroup) = std(flatVals)';
end