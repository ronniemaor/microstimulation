%% draw the slices on blood vessel image
mask = chamberMask(condsn);
blank = mean(conds(:,:,5),3);
meanFrame = mean(blank(:,2:100),2);
blVes = mfilt2(meanFrame,100,100,2,'hm');
W = 9;
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
W = 9;
C = [30,38];
[means,eqVals] = sliceTransform(signal,mask,C,W,vertical);
mmPerPixel = 0.1;
distances = eqVals * mmPerPixel; % convert to mm
msecPerFrame = 10;
times = (range-25)*msecPerFrame; % convert to msec from onset
figure; 
surf(times,distances,means); 
colorbar;
view(0,90);
if vertical; strAxis='vertical'; else strAxis='horizontal'; end;
title(sprintf('Signal strength for time and %s distance',strAxis));
xlabel('Time from stimulus onset (msec)'); 
ylabel('Distance from peak (mm)'); 
zlabel('Relative signal');

%% distance -> signal (at peak point)
mask = chamberMask(condsn);
peakRange = rangeFromWidth(33,9);
signal = relativeSignal(condsn,peakRange);
vertical = 0;
W = 9;
C = [30,38];

[eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical);
mmPerPixel = 0.1;
distances = eqVals * mmPerPixel; % convert to mm

[a,mu,sigma,R2] = bestGaussian(distances,eqMeans);
fprintf('a=%g, mu=%g, sigma=%g, R2=%g\n', a, mu, sigma, R2);

myGauss = @(x) a*exp(-0.5*((x-mu)/sigma)^2);
fit = arrayfun(myGauss,distances);
nAvgFactor = 1; % number of samples that went into our average (for estimating std)

figure;
errorbar(distances, eqMeans, eqStd*sqrt(nAvgFactor));
hold on
plot(distances, fit, 'r');
if vertical; strAxis='vertical'; else strAxis='horizontal'; end;
title(sprintf('Signal strength for %s distance',strAxis));
xlabel('Distance from peak center (mm)'); 
ylabel('Relative signal');
grid on
legend('Measured values', 'Gaussian fit');

%% how guassian fit parameters change over time
frameRange = 28:38;
W = 9;
C = [30,38];
vertical = 1;
[a,mu,sigma,R2] = fitsOverTime(condsn, frameRange, W, C, vertical);

figure

subplot(2,2,1);
plot(frameRange, a)
title('Parameter a')
ylabel('a')
xlabel('Frame')

subplot(2,2,2);
plot(frameRange, mu)
title('Parameter \mu')
ylabel('\mu')
xlabel('Frame')

subplot(2,2,3);
plot(frameRange, sigma)
title('Parameter \sigma')
ylabel('\sigma')
xlabel('Frame')

subplot(2,2,4);
plot(frameRange, R2)
title('Explained Variance')
ylabel('R2')
xlabel('Frame')

if vertical; strAxis='vertical'; else strAxis='horizontal'; end;
t = sprintf('Fit parameters for %s slice, frames %d-%d', ...
            strAxis, min(frameRange), max(frameRange));
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1], ...
          'Box','off', 'Visible','off', ...
          'Units','normalized', 'clipping' , 'off');
text(0.5,1,['\bf ' t],'HorizontalAlignment', 'center', 'VerticalAlignment', 'top')
