function timeCourseSeveralSessions(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    parms.fit = take_from_struct(parms,'fit',GaussianFit);
    allSessions = getSessionsFromParms(parms);
    
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
        0.5, 0.5, 0.5 ...
    ];

    maxVals = NaN*zeros(1,nParams+1);
    minVals = NaN*zeros(1,nParams+1);
    maxFrame = NaN;
    minFrame = NaN;

    figure
    iSession = 0;
    for cSession = allSessions
        iSession = iSession + 1;
        sessionKey = cSession{1};
        sessionNames{iSession} = sessionKey;
       
        for iSlice = 1:2
            isVertical = iSlice==2;
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
                plot(frames,vals, 'Color', colors(iSession,:))
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
            plot(frames, vals, 'Color', colors(iSession,:))
            hold on
            title('R2')
            ylabel('R2')
            xlabel('Frame')
        end
        
        % adjust y axis for params
        for xPlot = 1:(nParams+1)
            for iSlice = 1:2
                iPlot = nCols*(iSlice-1) + xPlot;
                subplot(nRows,nCols,iPlot);
                ylim([minVals(xPlot) maxVals(xPlot)]);
                if xPlot <= nParams % not the R2 plot
                    xlim([minFrame maxFrame])
                end
            end
        end
        drawnow
    end
    
    legend(sessionNames, 'Position', [0.72, 0.28 0.07 0.5])
    topLevelTitle(sprintf('Time course of %s parameters for all sessions', parms.fit.name()));
end