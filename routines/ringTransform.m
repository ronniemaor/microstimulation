function [means, rVals] = ringTransform(frames,mask,W)
N = [100 100];
C = [41 41]; % HARDCODED stimulation point
R = rings(N,C,mask,W);
[means,rVals] = mfEqMeans(frames,R);
