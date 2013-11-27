function timeCourseSeveralSessions(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    parms.fit = take_from_struct(parms,'fit',GaussianFit);
    allSessions = getSessionsFromParms(parms);
    summary = lower(take_from_struct(parms,'summary','none'));
    bShowMean = false;
    bShowMedian = false;
    medianErrWidth = take_from_struct(parms,'medianErrWidth',15); % in percentile units
    if isequal(summary,'mean')
        bShowMean = true;
    elseif isequal(summary,'median')
        bShowMedian = true;
    else
        assert(isequal(summary,'none'))
    end
    bShowSummary = bShowMean || bShowMedian;
    
    paramNames = parms.fit.paramNames();
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
        0.25, 0.25, 0.25; ...
        0,    0.25, 0; ...
        0.25, 0, 0; ...
        0,    0,    0.5; ...
        0.25, 0,    1; ...
        0.5,  0.5,  0.5; ...
        0.5   0.25, 0.75 ...
    ];

    maxVals = NaN*zeros(1,nParams+1);
    minVals = NaN*zeros(1,nParams+1);
    maxFrame = NaN;
    minFrame = NaN;

    figure
    for iSlice = 1:2       
        isVertical = iSlice==2;
        
        iSession = 0;
        for cSession = allSessions
            iSession = iSession + 1;
            sessionKey = cSession{1};
            sessionNames{iSession} = sessionKey;
            
            P = cacheTimeCourseParams(sessionKey, parms);        
            sliceStruct = P.(sliceName(isVertical));

            frames = sliceStruct.goodFrames;
            maxFrame = max(max(frames),maxFrame);
            minFrame = min(min(frames),minFrame);            
            
            for iParam = 1:nParams
                name = paramNames{iParam};
                vals = sliceStruct.(name);
                maxVals(iParam) = max(max(vals),maxVals(iParam));
                minVals(iParam) = min(min(vals),minVals(iParam));

                iPlot = nCols*(iSlice-1) + iParam;
                subplot(nRows,nCols,iPlot)
                if bShowSummary; c = 0.75*[1 1 1]; else c = colors(iSession,:); end
                hLine = plot(frames,vals, 'Color', c,'LineWidth', 2, 'Marker','o', 'MarkerSize', 3);
                if bShowSummary && iSession > 1
                    set(get(get(hLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
                end
                hold on
                if iParam == 1
                    t = sprintf('%s - %s', sliceName(isVertical), name);
                else
                    t = name;
                end
                title(t)
                ylabel(name)
                xlabel('Frame')
            end

            % R2
            frames = P.frameRange;
            vals = sliceStruct.R2;
            maxVals(iParam+1) = max(max(vals),maxVals(iParam+1));
            minVals(iParam+1) = min(min(vals),minVals(iParam+1));
            iPlot = nCols*(iSlice-1) + nParams+1;
            subplot(nRows,nCols,iPlot);
            if bShowSummary; c = 0.75*[1 1 1]; else c = colors(iSession,:); end
            plot(frames, vals, 'Color', c,'LineWidth', 2)
            hold on
            title('R2')
            ylabel('R2')
            xlabel('Frame')
        end

        % compute means over contributing sessions for each frame
        if bShowSummary
            for iParam = 1:nParams
                name = paramNames{iParam};
                
                % gather all the values from all sessions
                allSessionVals = NaN*zeros(nSessions, maxFrame);
                iSession = 0;
                for cSession = allSessions
                    iSession = iSession + 1;
                    P = cacheTimeCourseParams(cSession{1}, parms);        
                    sliceStruct = P.(sliceName(isVertical));
                    frames = sliceStruct.goodFrames;
                    vals = sliceStruct.(name);
                    allSessionVals(iSession,frames) = vals;
                end
                
                if bShowMean
                    % compute the mean
                    allSessionMeans = nanmean(allSessionVals,1);
                    allSessionSem = nanstd(allSessionVals,1) ./ sqrt(sum(~isnan(allSessionVals),1));
                    frames = find(~isnan(allSessionMeans));
                    allSessionMeans = allSessionMeans(frames);
                    allSessionSem = allSessionSem(frames);

                    % plot it
                    iPlot = nCols*(iSlice-1) + iParam;
                    subplot(nRows,nCols,iPlot);
                    errorbar(frames,allSessionMeans,allSessionSem, 'Color', 'b', 'LineWidth', 2, 'Marker','o', 'MarkerSize', 3)
                elseif bShowMedian
                    % compute the median and percentils
                    allSessionMedians = nanmedian(allSessionVals,1);
                    allSessionLowPct = prctile(allSessionVals, 50 - medianErrWidth);
                    allSessionHighPct = prctile(allSessionVals, 50 + medianErrWidth);
                    frames = find(~isnan(allSessionMedians));
                    allSessionMedians = allSessionMedians(frames);
                    allSessionLowPct = allSessionLowPct(frames);
                    allSessionHighPct = allSessionHighPct(frames);

                    % plot it
                    iPlot = nCols*(iSlice-1) + iParam;
                    subplot(nRows,nCols,iPlot);
                    L = allSessionMedians - allSessionLowPct;
                    H = allSessionHighPct - allSessionMedians;
                    errorbar(frames,allSessionMedians,L,H, 'Color', 'b', 'LineWidth', 2, 'Marker','o', 'MarkerSize', 3)                    
                end
            end        
        end
        
        % adjust y axis for params
        for xPlot = 1:(nParams+1)
            iPlot = nCols*(iSlice-1) + xPlot;
            subplot(nRows,nCols,iPlot);
            ylim([minVals(xPlot) maxVals(xPlot)]);
            if xPlot <= nParams % not the R2 plot
                xlim([minFrame maxFrame])
            end
        end
        drawnow
    end
    
    h = subplot(nRows,nCols,1);
    if bShowSummary
        legendNames = {'Single Sessions', };
        if bShowMean
            legendNames{2} = 'Mean \pm sem';
        elseif bShowMedian
            legendNames{2} = sprintf('Median \\pm %d pct',medianErrWidth);
        else
            assert(false,'unsupported summary option');
        end
    else
        legendNames = sessionNames;
    end
    legendPos = [0.72, 0.28 0.07 0.5];
    legend(h,legendNames, 'Position', legendPos)
    
    % Draw R2 threshold
    % Draw it after legend, so it doesn't mess up the legend. I'm sure there's a better way to do this...
    P = cacheTimeCourseParams(sessionKey, parms);        
    for iSlice = 1:2
        R2_threshold = 0.6; % XXX - duplication of the value in cacheTimeCourseParams
        iPlot = nCols*(iSlice-1) + nParams+1;
        subplot(nRows,nCols,iPlot);
        plot([min(P.frameRange) max(P.frameRange)], [R2_threshold R2_threshold], 'r--')
    end
    
    topLevelTitle(sprintf('Time course of %s parameters for all sessions', parms.fit.name()));
end