%% draw the slices on blood vessel image
mask = chamberMask(blank);
meanFrame = mean(rawBlank(:,2:100),2);
blVes = mfilt2(meanFrame,100,100,2,'hm');
W = 9;
vertical = 0;
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
peakRange = peakFrame; % rangeFromWidth(peakFrame,3);
signal = relativeSignal(blank,stims,peakRange);
W = 9;
nBins = 2;
fits = {GaussianFit(1), ExponentialFit(1)};
fitNames = cellfun(@(fit) fit.name(),fits, 'UniformOutput',false);
figure
nFits = length(fits);

nSlices = 2;
errCases = zeros(nSlices,nFits);
errSemCases = zeros(nSlices,nFits);
sliceNames = cell(1,nSlices);

for iSlice = 1:2
    vertical = iSlice == 2;
    if vertical; strAxis='Vertical'; else strAxis='Horizontal'; end;
    sliceNames{iSlice} = strAxis;
    [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials
    
    subplot(2,2,iSlice)
    errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
    hold on
    colors = get(gca,'ColorOrder');

    for iFit = 1:nFits
        fit = fits{iFit};
        [yFit,P,err,errSem, overfitR2] = ...
                   crossValidationRegression(fit,distances,eqMeans,nBins);
        errCases(iSlice,iFit) = err;
        errSemCases(iSlice,iFit) = errSem;
        plot(distances, yFit, 'Color', colors(iFit+1,:));
        title(sprintf('%s slice',strAxis));
        xlabel('Distance from peak center (mm)'); 
        ylabel('Relative signal');
    end
    legend('Measured values', fitNames{:});
end

subplot(2,2,[3 4])
barwitherr(errSemCases, errCases);
title('Goodness of fit for the different models');
set(gca,'XTickLabel',sliceNames)
ylabel('R2')
legend(fitNames,'Location','North')

topVals = errCases + errSemCases;
bottomVals = errCases - errSemCases;
ymax = max(topVals(:));
ymin = min(bottomVals(:));
ylim([max(0,ymin-0.2), min(1,ymax+0.05)])

if length(peakRange) > 1
    strFrames = sprintf('frames %d:%d', min(peakRange), max(peakRange));
else
    strFrames = sprintf('frame %d', peakRange);
end
t = sprintf('Fits for %s, W=%d, C=(%d,%d)', strFrames, W, C(1), C(2));
topLevelTitle(t);

%% how fit parameters change over time
frameRange = rangeFromWidth(peakFrame,11);
% fit = ExponentialFit(1);
fit = GaussianFit(0);
for isVertical = 0:1
    timeCourse(blank, stims, C, 25:45, isVertical, fit, 25:35)
end

%% movie of how signal(distance) curve changes over time
mask = chamberMask(blank);
frameRange = 26:40;
W = 9;
nFrames = length(frameRange);
vertical = 0;

writerObj = VideoWriter('response','MPEG-4');
writerObj.open()
for iFrame = 1:nFrames
    frameNumber = frameRange(iFrame);
    signal = relativeSignal(blank,stims,frameNumber);
    [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials    
    errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
    title(sprintf('Frame %d',frameNumber))
    frame = getframe;
    for iDup = 1:10
        writerObj.writeVideo(frame);
    end
end
writerObj.close()