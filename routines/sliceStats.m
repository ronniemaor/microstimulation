function [eqMeans, eqStd, eqVals] = sliceStats(frames,mask,C,W,vertical)
N = [100 100];
Eq = sliceEqGroups(N,C,mask,W,vertical);
[eqMeans, eqStd, eqVals] = eqStats(frames,Eq);
