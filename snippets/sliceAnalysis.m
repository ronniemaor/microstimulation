%% draw the slices on blood vessel image
mask = chamberMask(blank);
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
mask = chamberMask(blank);
range = 2:230;
signal = relativeSignal(blank,stims,range);
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
mask = chamberMask(blank);
peakRange = rangeFromWidth(33,9);
signal = relativeSignal(blank,stims,peakRange);
vertical = 0;
W = 9;
C = [30,38];

[eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical);
mmPerPixel = 0.1;
distances = eqVals * mmPerPixel; % convert to mm
eqStd = mean(eqStd,1); % estimate std over all trials

nBins = 5;
[yFit,P,R2] = crossValidationRegression(GaussianFit,distances,eqMeans,nBins);
fprintf('a=%g, mu=%g, sigma=%g, R2=%g\n', P, R2);

figure;
errorbar(distances, mean(eqMeans,1), eqStd);
hold on
plot(distances, yFit, 'r');
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
nBins = 5;
[a,mu,sigma,R2] = fitsOverTime(blank, stims, frameRange, ...
                               W, C, vertical, nBins);

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
