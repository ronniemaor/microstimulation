%% draw the circles on blood vessel image
blank = mean(conds(:,:,5),3);
meanFrame = mean(blank(:,2:100),2);
blVes = mfilt2(meanFrame,100,100,2,'hm');
mask = chamberMask(condsn);
R = rings([100,100],[41,41],mask,3);
blVes(R==10) = min(blVes);
%blVes(maskPix) = min(blVes);
figure; mimg(blVes,100,100); impixelinfo;

%% surface plot after radius transform
signal = relativeSignal(condsn);
mask = chamberMask(condsn);
means = ringTransform(signal,mask,3);
means = means(1:18,:);
figure; surf(means); colorbar;
set(gca,'XTick',[25, 50:50:200]);
xlabel('Frame'); ylabel('Radius'); zlabel('Signal'); 

%% signal vs. radius for several time points
signal = relativeSignal(condsn);
mask = chamberMask(condsn);
means = ringTransform(signal,mask,3);
%frames = 32:2:50; 
frames = 24:2:32;
means = means(1:18,frames);
figure; plot(means); 
xlabel('Radius'); ylabel('Signal');
legend(arraySprintf('Frame %d',frames))

%% signal vs. time for several radiuses
signal = relativeSignal(condsn);
mask = chamberMask(condsn);
means = ringTransform(signal,mask,3);
radiuses = [0, 5, 10]; 
%radiuses = 0:2:10;
means = means(radiuses+1,:);
figure; plot(means'); 
xlabel('Frame'); ylabel('Signal');
legend(arraySprintf('Radius %d',radiuses));
