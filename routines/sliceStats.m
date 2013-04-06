function [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical)
N = [100 100];
Eq = sliceEqGroups(N,C,mask,W,vertical);
[eqMeans, eqStd, eqVals] = eqStats(signal,Eq);

% take one side - the one with the most values
if -min(eqVals) > max(eqVals)
    eqVals = -eqVals; % make the values positive in any case
end
positions = (eqVals >= 0); % now take only the positive side
eqMeans = eqMeans(:,positions);
eqStd = eqStd(:,positions);
eqVals = eqVals(positions);
