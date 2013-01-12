%% draw the slices on blood vessel image
mask = chamberMask(condsn);
blank = mean(conds(:,:,5),3);
meanFrame = mean(blank(:,2:100),2);
blVes = mfilt2(meanFrame,100,100,2,'hm');
W = 3;
vertical = 0;
C = [30,38];
Eq = sliceEqGroups([100,100],C,mask,W,vertical);
%blVes(mask) = mean(blVes); % show chamber mask
%region = ~isnan(Eq); % show whole slice
region = Eq == 0; % show one position on slice
blVes(region) = min(blVes);
figure; mimg(blVes,100,100); impixelinfo;

%% time*distance -> signal
mask = chamberMask(condsn);
range = 2:230;
signal = relativeSignal(condsn,range);
vertical = 0;
W = 3;
C = [30,38];
[means,eqVals] = sliceTransform(signal,mask,C,W,vertical);
mmPerPixel = 0.1;
distances = eqVals * W * mmPerPixel; % convert to mm
msecPerFrame = 10;
times = (range-25)*10; % convert to msec from onset
figure; 
surf(times,distances,means); 
colorbar;
view(0,90);
if vertical; strAxis='vertical'; else strAxis='horizontal'; end;
title(sprintf('Signal strength for time and %s distance',strAxis));
xlabel('Time from stimulus onset (msec)'); 
ylabel('Distance from peak (mm)'); 
zlabel('Relative signal');

%% distnace -> signal (at peak point)
mask = chamberMask(condsn);
peakRange = 32:34;
signal = relativeSignal(condsn,peakRange);
vertical = 0;
W = 3;
C = [30,38];
[means,eqVals] = sliceTransform(signal,mask,C,W,vertical);
peakSlice = mean(means,2); % average the frames around the peak
mmPerPixel = 0.1;
distances = eqVals * W * mmPerPixel; % convert to mm

scale = 10000; % hack for optimization to converge

[a,b,mu,sigma] = bestGaussian(distances,peakSlice'*scale);
a = a/scale;
b = b/scale;
fprintf('a=%g, b=%g, mu=%g, sigma=%g\n', a, b, mu, sigma);

myGauss = @(x) a*exp(-0.5*((x-mu)/sigma)^2) + b;
fit = arrayfun(myGauss,distances);

figure;
plot(distances,peakSlice, distances, fit); 
if vertical; strAxis='vertical'; else strAxis='horizontal'; end;
title(sprintf('Signal strength for %s distance',strAxis));
xlabel('Distance from peak center (mm)'); 
ylabel('Relative signal');
grid on
legend('Measured values', 'Gaussian fit');