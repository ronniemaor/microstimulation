%% Create blood vessels map
% after running 'create_conds.m' on all files from cond 3 (blank)
% and NOT deviding in zero frame (use the folowing line: condz = ones(10000,1);)
blVes = mean(blank(:,2:100),2);
figure; mimg(mfilt2(blVes,100,100,2,'hm'),100,100); impixelinfo;

