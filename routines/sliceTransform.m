function [means, eqVals] = sliceTransform(frames,mask,C,W,vertical)
N = [100 100];
Eq = sliceEqGroups(N,C,mask,W,vertical);
[means,eqVals] = mfEqMeans(frames,Eq);
