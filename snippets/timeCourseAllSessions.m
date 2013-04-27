function timeCourseAllSessions(fit, frameRange, specificSessions)
    if nargin < 3 
        allConfigs = getSessionConfigs();
        allSessions = allConfigs.keys();
    else
        allSessions = specificSessions;
    end
    W = 9;
    nBins = 2;
    R2_threshold = 0.6; % don't use points below this threshold
    sigma_threshold = 10; % don't use points above this sigma (Gaussian fit only)
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    nCols = nParams + 2;
    nRows = 2; % vertical/horizontal
        
    nSessions = length(allSessions);
    sessionNames = cell(1,nSessions);    
    
    colors = [ ...
        0,    0,    1; ...
        0,    0.5,  0; ...
        1,    0,    0; ...
        0,    0.75, 0.75; ...
        0.75, 0,    0.75; ...
        0.75, 0.75, 0; ...
        0.25, 0.25, 0.25 ...
    ];

    figure
    iSession = 0;
    for cSession = allSessions
        iSession = iSession + 1;
        sessionKey = cSession{1};
        sessionNames{iSession} = sessionKey;
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
                iPlot = nCols*(iSlice-1) + iParam;
                subplot(nRows,nCols,iPlot)
                plot(frameRange(goodPositions),P(iParam,goodPositions), 'Color', colors(iSession,:))
                hold on
                name = paramNames{iParam};
                if iParam == 1
                    t = sprintf('%s - %s', sliceName(isVertical), name);
                else
                    t = name;
                end
                title(t)
                ylabel(name)
                xlabel('Frame')
            end

            iPlot = nCols*(iSlice-1) + nParams+1;
            subplot(nRows,nCols,iPlot);
            plot(frameRange, err, 'Color', colors(iSession,:))
            hold on
            title('R2')
            ylabel('R2')
            xlabel('Frame')
        end
        drawnow
    end
    
    legend(sessionNames, 'Position', [0.72, 0.28 0.07 0.5])
    topLevelTitle(sprintf('Time course of %s parameters for all sessions', fit.name()));
end