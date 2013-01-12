function [means, rVals] = ringTransform(frames,mask,C,W)
N = [100 100];
R = rings(N,C,mask,W);
[means,rVals] = mfEqMeans(frames,R);
