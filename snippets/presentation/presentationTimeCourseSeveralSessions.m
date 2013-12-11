function presentationTimeCourseSeveralSessions()
    fit = GaussianFit;
    frameRange = 20:50;
    allSessions = {'M18b', 'M18c', 'M18d', 'M18e'};

    fontSize = 16;
    W = 9;
    nBins = 2;
    R2_threshold = 0.6; % don't use points below this threshold
    sigma_threshold = 10; % don't use points above this sigma (Gaussian fit only)
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    nCols = nParams;
    nRows = 2; % vertical/horizontal
        
    nSessions = length(allSessions);
    sessionNames = cell(1,nSessions);    
    
    colors = getColors();

    maxVals = NaN*zeros(1,nParams+1);
    minVals = NaN*zeros(1,nParams+1);
    maxTime = NaN;
    minTime = NaN;

    figure
    iSession = 0;
    for cSession = allSessions
        iSession = iSession + 1;
        sessionKey = cSession{1};
        sessionNames{iSession} = sprintf('%d \\mum', iSession*200);
        data = loadData(sessionKey);
        data = findPeak(data);
       
        for iSlice = 1:2
            isVertical = iSlice==2;
            
            [P, err, ~, ~] = fitsOverTime(fit, data.blank, data.stims, data.mask, frameRange, W, data.C, isVertical, nBins);

            highR2 = err > R2_threshold;
            goodPositions = highR2; % can't trust fits with R2 below this threshold
            for iParam = 1:nParams
                if strcmpi(paramNames{iParam},'sigma')
                    smallSigma = P(iParam,:) < sigma_threshold;
                    goodPositions = goodPositions & smallSigma;
                end
            end
            
            for iParam = 1:nParams
                goodTimes = 10 * (frameRange(goodPositions) - 25);
                maxTime = max(max(goodTimes),maxTime);
                minTime = min(min(goodTimes),minTime);
                goodP = P(iParam,goodPositions);
                maxVals(iParam) = max(max(goodP),maxVals(iParam));
                minVals(iParam) = min(min(goodP),minVals(iParam));

                iPlot = nCols*(iSlice-1) + iParam;
                subplot(nRows,nCols,iPlot)
                set(gca,'FontSize',fontSize);
                plot(goodTimes,goodP, 'Color', colors(iSession,:))
                hold on
                name = paramNames{iParam};
                if strcmpi(name,'sigma')
                    name = 'Width';
                end
                if strcmpi(name,'a')
                    name = 'Amplitude';
                end
                t = name;
                title(t)
                ylabel(name)
                xlabel('Time [msec]')
            end
        end
        
        % adjust y axis for params
        for xPlot = 1:nParams
            for iSlice = 1:2
                iPlot = nCols*(iSlice-1) + xPlot;
                subplot(nRows,nCols,iPlot);
                ylim([minVals(xPlot) maxVals(xPlot)]);
            end
        end
        drawnow
    end
    
    legend(sessionNames, 'Position', [0.72, 0.28 0.07 0.5])
    showSliceDirection(0)
    showSliceDirection(1)
end

function showSliceDirection(isVertical)
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1], ...
         'Box','off', 'Visible','off', ...
         'Units','normalized', 'clipping' , 'off');
    posX = 0.05;
    if isVertical
        posY = 0.27;
    else
        posY = 0.74;
    end
    t = sliceName(isVertical);
    text(posX,posY,['\bf ' t], ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'top', ...
         'Rotation', 90, ...
         'FontSize', 18)
end