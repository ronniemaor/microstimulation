%% Create blood vessels map
% after running 'create_conds.m' on all files from cond 3 (blank)
% and NOT deviding in zero frame (use the folowing line: condz = ones(10000,1);)
blVes = mean(conds(:,:,5),3);
figure; mimg(mfilt2(mean(blVes(:,2:100),2),100,100,2,'hm'),100,100); impixelinfo;

