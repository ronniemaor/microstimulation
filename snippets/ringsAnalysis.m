%% draw the circles on blood vessel image
mask = chamberMask(blank);
meanFrame = mean(blank(:,2:100),2);
blVes = mfilt2(meanFrame,100,100,2,'hm');
C = [30,38];
W = 3;
R = rings([100,100],C,mask,W);
blVes(R==10) = min(blVes);
%blVes(maskPix) = min(blVes);
figure; mimg(blVes,100,100); impixelinfo;

%% surface plot after radius transform
range = 2:230;
signal = relativeSignal(blank,stims,range);
mask = chamberMask(blank);
W = 3;
C = [30,38];
[means,rVals] = ringTransform(signal,mask,C,W);
mmPerPixel = 0.1;
distances = rVals * W * mmPerPixel; % convert to mm
msecPerFrame = 10;
times = (range-25)*10; % convert to msec from onset
figure; 
surf(times,distances,means);
view(0,90);
colorbar;
title('Signal strength for time and radius');
xlabel('Time from stimulus onset (msec)'); 
ylabel('Radius from peak (mm)'); 
zlabel('Signal'); 

%% signal vs. radius for several time points
signal = relativeSignal(blank,stims);
mask = chamberMask(blank);
W = 3;
C = [30,38];
means = ringTransform(signal,mask,C,W);
%frames = 32:2:50; 
frames = 24:2:32;
means = means(1:18,frames);
figure; plot(means); 
xlabel('Radius'); ylabel('Signal');
legend(arraySprintf('Frame %d',frames))

%% signal vs. time for several radiuses
signal = relativeSignal(blank,stims);
mask = chamberMask(blank);
W = 3;
C = [30,38];
means = ringTransform(signal,mask,C,W);
radiuses = [0, 5, 10]; 
%radiuses = 0:2:10;
means = means(radiuses+1,:);
figure; plot(means'); 
xlabel('Frame'); ylabel('Signal');
legend(arraySprintf('Radius %d',radiuses));
