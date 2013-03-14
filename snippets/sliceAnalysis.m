%% draw the slices on blood vessel image
mask = chamberMask(blank);
meanFrame = mean(blank(:,2:100),2);
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
%fit = GaussianFit;
fit = ExponentialFit;
%fit = ExactFit;
nBins = 2;

figure
for iSlice = 1:2
    vertical = iSlice == 2;
    [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials

    [yFit,P,err,errSem, overfitR2] = ...
               crossValidationRegression(fit,distances,eqMeans,nBins);
    paramNames = fit.paramNames();
    strParams = '';
    for iParam = 1:length(paramNames)
        strParams = [strParams, sprintf('%s=%.2g, ', ...
                     paramNames{iParam}, P(iParam))];
    end
    strErr = sprintf('R2(overfit)=%.2g\nnBins=%d, R2=%.2g +/- %.2g', ...
                     overfitR2, nBins, err, errSem);

    subplot(1,2,iSlice)
    errorbar(distances, mean(eqMeans,1), eqSEM);
    hold on
    plot(distances, yFit, 'r');
    if vertical; strAxis='Vertical'; else strAxis='Horizontal'; end;
    title(sprintf('%s slice\n%s\n%s',strAxis,strParams,strErr));
    xlabel('Distance from peak center (mm)'); 
    ylabel('Relative signal');
    grid on
    legend('Measured values', fit.name());
end

if length(peakRange) > 1
    strFrames = sprintf('frames %d:%d', min(peakRange), max(peakRange));
else
    strFrames = sprintf('frame %d', peakRange);
end
t = sprintf('%s for %s, W=%d, C=(%d,%d)', fit.name(), strFrames, W, C(1), C(2));
topLevelTitle(t);

%% how fit parameters change over time
frameRange = 28:38;
W = 9;
vertical = 0;
%fit = GaussianFit;
fit = ExponentialFit;
%fit = ExactFit;
nBins = 2;

[P, err, errSem, overfitR2] = ...
    fitsOverTime(fit, blank, stims, frameRange, W, C, vertical, nBins);

paramNames = fit.paramNames();
nParams = length(paramNames);
nPlots = nParams + 2;
nCols = ceil(sqrt(nPlots));
nRows = ceil(nPlots/nCols);

figure
for iParam = 1:nParams
    subplot(nRows,nCols,iParam)
    plot(frameRange,P(iParam,:))
    name = paramNames{iParam};
    title(['Parameter ', name])
    ylabel(name)
    xlabel('Frame')
end

subplot(nRows,nCols,nParams+1);
plot(frameRange, overfitR2)
title('R2 (overfit)')
ylabel('R2')
xlabel('Frame')

subplot(nRows,nCols,nParams+2);
plot(frameRange, err)
errorbar(frameRange, err, errSem);
title('R2')
ylabel('R2')
xlabel('Frame')

if vertical; strAxis='vertical'; else strAxis='horizontal'; end;
t = sprintf('%s parameters for %s slice, frames %d:%d W=%d, C=(%d,%d)', ...
            fit.name(), strAxis, min(frameRange), max(frameRange), ...
            W, C(1), C(2));
topLevelTitle(t);

