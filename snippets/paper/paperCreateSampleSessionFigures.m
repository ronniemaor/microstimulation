function paperCreateSampleSessionFigures()
    fontSize = 18;
    data = loadData('M18c');
    isVertical = 1;
    frameRange = 20:60;
    fit = GaussianFit;
    specialFrames = [26 29 32];

    R2_threshold = 0.6;    
    W = 9;
    nBins = 2;
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);

    data = findPeak(data);
    [P, err, ~, ~] = fitsOverTime(fit, ... 
                                       data.blank, data.stims, data.mask, ...
                                       frameRange, W, data.C, ...
                                       isVertical, nBins);

    highR2 = err > R2_threshold;
    goodPositions = highR2; % can't trust fits with R2 below this threshold
                  
    times = 10 * (frameRange - 25);
    for iParam = 1:nParams
        goodTimes = times(goodPositions);
        name = paramNames{iParam};
        paramVals = P(iParam,goodPositions);
        if strcmpi(name,'sigma')
            name = 'Width';
            paramVals(paramVals > 10) = NaN;
        end
        if strcmpi(name,'a')
            name = 'Amplitude';
        end
        figure
        plot(goodTimes,paramVals)
        set(gca,'FontSize',fontSize)
        title([name,'(t)'])
        ylabel(name)
        xlabel('Time from stimulus [msec]')        
    end

    figure
    plot(times, err, 'b');
    hold on
    plot([min(times) max(times)], [R2_threshold R2_threshold], 'r');
    set(gca,'FontSize',fontSize)
    title('Goodness of fit')
    ylabel('R2')
    xlabel('Time from stimulus [msec]')

    for iSpecial = 1:length(specialFrames)
        frame = specialFrames(iSpecial);
        signal = relativeSignal(data.blank, data.stims,frame);
        strTitle = sprintf('%d msec',10*(frame-25));
        bYLegend = (iSpecial == 1);
        figure
        drawOne(data.mask,signal,data.C,W,isVertical,fit,strTitle,fontSize,bYLegend)
    end
end

function drawOne(mask,signal,C,W,isVertical,fit,strTitle,fontSize,bYLegend)
    nBins = 2;
    [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials
    
    set(gca,'FontSize',fontSize)
    errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
    hold on
           
    yFit = crossValidationRegression(fit,distances,eqMeans,nBins);
    plot(distances, yFit);
    title(strTitle);
    xlabel('Distance from center (mm)'); 
    if bYLegend
        ylabel('Relative signal');
    else
        set(gca,'YTick',[])
        set(gca,'YTickLabel',[])
    end
    ylim([0 2.2E-3])
    xlim([0 5])
end