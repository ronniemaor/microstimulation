function [means, rVals] = ringTransform(signal,mask,C,W)
N = [100 100];
R = rings(N,C,mask,W);
[means,rVals] = mfEqMeans(signal,R);
