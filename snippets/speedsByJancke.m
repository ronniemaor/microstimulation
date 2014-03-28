function speeds = speedsByJancke(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    allSessions = getSessionsFromParms(parms);
    
    medianErrWidth = take_from_struct(parms,'medianErrWidth',15); % in percentile units
    
    [threshold,parms] = take_from_struct(parms, 'threshold', 2.5E-4);    
    parms.thresholds = threshold; % use the single threshold
    
    nSessions = 0;
    sessionNames = {};
    speeds = [];
    for cSession = allSessions
        sessionKey = cSession{1};
        sH = findSpeed(sessionKey,0,parms);
        assert(length(sH) == 1, 'Using multiple thresholds?');
        sV = findSpeed(sessionKey,1,parms);
        assert(length(sV) == 1, 'Using multiple thresholds?');
        if isnan(sH) || isnan(sV)
            continue
        end
        nSessions = nSessions + 1;
        sessionNames{nSessions} = sprintf('%s - %s', sessionKey, formatStimulationParams(sessionKey)); 
        speeds(nSessions,:) = [sH sV];
    end

    meanSpeeds = mean(speeds,1);
    errSpeeds = std(speeds,0,1)/sqrt(nSessions);
    medianSpeeds = median(speeds,1);

    X = speeds(:,1);
    Y = speeds(:,2);
    d = X-Y;
    pvalue = signrank(d);
    if median(d) > 0 % convert two tailed to one tailed pvalue
        pvalue = pvalue / 2;
    else
        pvalue = 1 - pvalue / 2;
    end

    colors = getColors();
    
    myfigure(parms);
    maxSpeed = max(speeds(:));
    for i=1:nSessions
        plot(X(i),Y(i),'o','Color',colors(i,:), 'MarkerSize', 8, 'LineWidth',2);
        hold on;
    end
    plot(meanSpeeds(1), meanSpeeds(2), 'x', 'Color','g', 'MarkerSize', 14, 'LineWidth', 3)
    plot(medianSpeeds(1), medianSpeeds(2), 'x', 'Color','b', 'MarkerSize', 14, 'LineWidth', 3)
    ttl1 = sprintf('Speed anisotropy for \\Deltaf/f=%g*10^{-4}', threshold*1E4);
    ttl2 = sprintf('p-value for H > V = %.2g', pvalue);
    title(sprintf('%s\n%s',ttl1,ttl2))
    legendLabels = sessionNames;
    legendLabels{nSessions+1} = 'Mean \pm sem';
    legendLabels{nSessions+2} = sprintf('Median \\pm %d pct',medianErrWidth);
    hLegend = legend(legendLabels{:},'Location','NorthWest');
    set(hLegend,'FontSize',10);
    axis equal
    xlabel('Horizontal speed [cm/s]')
    ylabel('Vertical speed [cm/s]')
    lim = [0 1.1*maxSpeed];
    xlim(lim);
    ylim(lim);
    hold on
    plot(lim,lim,'g')
    % error bars of mean
    plot([meanSpeeds(1)-errSpeeds(1) meanSpeeds(1)+errSpeeds(1)], [meanSpeeds(2) meanSpeeds(2)], 'g-', 'LineWidth', 2)
    plot([meanSpeeds(1) meanSpeeds(1)], [meanSpeeds(2)-errSpeeds(2) meanSpeeds(2)+errSpeeds(2)], 'g-', 'LineWidth', 2)
    % error bars of median
    lowPct = 50 - medianErrWidth;
    highPct = 50 + medianErrWidth;
    plot([prctile(speeds(:,1),lowPct) prctile(speeds(:,1),highPct)], [medianSpeeds(2) medianSpeeds(2)], 'b-', 'LineWidth', 2)
    plot([medianSpeeds(1) medianSpeeds(1)], [prctile(speeds(:,2),lowPct) prctile(speeds(:,2),highPct)], 'b-', 'LineWidth', 2)
end

function s = findSpeed(sessionKey,isVertical,parms)
    s = activationBoundaryFits(sessionKey,isVertical, add_parms(parms, 'bPlot',false));
end
