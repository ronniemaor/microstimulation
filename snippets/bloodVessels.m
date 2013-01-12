%% Create blood vessels map
% after running 'create_conds.m' on all files from cond 3 (blank)
% and NOT deviding in zero frame (use the folowing line: condz = ones(10000,1);)
blVes = mean(conds(:,:,5),3);
figure; mimg(mfilt2(mean(blVes(:,2:100),2),100,100,2,'hm'),100,100); impixelinfo;

%% draw the circles on blood vessel image
blank = mean(conds(:,:,5),3);
meanFrame = mean(blank(:,2:100),2);
blVes = mfilt2(meanFrame,100,100,2,'hm');
R = rings([100,100],[41,41],mask,3);
blVes(R==10) = min(blVes);
%blVes(maskPix) = min(blVes);
figure; mimg(blVes,100,100); impixelinfo;

