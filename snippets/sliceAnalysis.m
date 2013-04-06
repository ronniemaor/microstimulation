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
fits = {OneSidedGaussianFit, OneSidedExponentialFit};

figure
nFits = length(fits);
for iFit = 1:nFits
    fit = fits{iFit};
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
        strErr = sprintf('R2=%.2g \\pm %.2g (w/o CV=%.2g)', ...
                         err, errSem, overfitR2);

        subplot(nFits,2,nFits*(iFit-1) + iSlice)
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
end

if length(peakRange) > 1
    strFrames = sprintf('frames %d:%d', min(peakRange), max(peakRange));
else
    strFrames = sprintf('frame %d', peakRange);
end
t = sprintf('Fits for %s, W=%d, C=(%d,%d)', strFrames, W, C(1), C(2));
topLevelTitle(t);

%% compare fit of different families
mask = chamberMask(blank);
peakRange = peakFrame; % rangeFromWidth(peakFrame,3);
signal = relativeSignal(blank,stims,peakRange);
W = 9;
nBins = 2;
fits = {OneSidedGaussianFit, OneSidedExponentialFit};

nSlices = 2;
nFits = length(fits);
errCases = zeros(nSlices,nFits);
errSemCases = zeros(nSlices,nFits);
fitNames = cell(1,nFits);
sliceNames = cell(1,nSlices);

for iFit = 1:nFits
    fit = fits{iFit};
    fitNames{iFit} = fit.name();
    for iSlice = 1:nSlices
        vertical = iSlice == 2;
        if vertical; strAxis='Vertical'; else strAxis='Horizontal'; end;
        sliceNames{iSlice} = strAxis;
        
        [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,vertical);
        mmPerPixel = 0.1;
        distances = eqVals * mmPerPixel; % convert to mm
        eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials

        [yFit,P,err,errSem, overfitR2] = ...
                   crossValidationRegression(fit,distances,eqMeans,nBins);
        errCases(iSlice,iFit) = err;
        errSemCases(iSlice,iFit) = errSem;
    end
end

figure
barwitherr(errSemCases, errCases);
title('Goodness of fit for the different models');
set(gca,'XTickLabel',sliceNames)
ylabel('R2')
legend(fitNames,'Location','NorthEastOutside')

topVals = errCases + errSemCases;
bottomVals = errCases - errSemCases;
ymax = max(topVals(:));
ymin = min(bottomVals(:));
ylim([max(0,ymin-0.2), min(1,ymax+0.05)])

%% how fit parameters change over time
frameRange = rangeFromWidth(peakFrame,11);
W = 9;
nBins = 2;
fits = {OneSidedExponentialFit};

nFits = length(fits);
for iFit = 1:nFits
    fit = fits{iFit};
    
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    nPlots = nParams + 2;
    nCols = ceil(sqrt(nPlots));
    nRows = ceil(nPlots/nCols);
    
    for iSlice = 1:2
        vertical = iSlice == 2;

        [P, err, errSem, overfitR2] = fitsOverTime(fit, blank, stims, ...
                                                   frameRange, W, C, ...
                                                   vertical, nBins);

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
    end
end
