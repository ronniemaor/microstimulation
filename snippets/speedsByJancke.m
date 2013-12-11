function speeds = speedsByJancke(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    allSessions = getSessionsFromParms(parms);
    
    medianErrWidth = take_from_struct(parms,'medianErrWidth',15); % in percentile units
    
    [threshold,parms] = take_from_struct(parms, 'threshold', 1E-3 * 0.25);    
    parms.thresholds = threshold; % use the single threshold
    
    nSessions = 0;
    sessionNames = {};
    speeds = [];
    for cSession = allSessions
        sessionKey = cSession{1};
        if isequal(sessionKey,'J29j') 
            continue % no fits for Horizontal, non linear sigma changes for Vertical (maybe we can use only vertical?)
        end;
        nSessions = nSessions + 1;
        sessionNames{nSessions} = sprintf('%s - %s', sessionKey, formatStimulationParams(sessionKey)); 
        sH = findSpeed(sessionKey,0,parms);
        assert(length(sH) == 1, 'Using multiple thresholds?');
        sV = findSpeed(sessionKey,1,parms);
        assert(length(sV) == 1, 'Using multiple thresholds?');
        speeds(nSessions,:) = [sH sV];
    end

    meanSpeeds = mean(speeds,1);
    errSpeeds = std(speeds,0,1)/sqrt(nSessions);
    medianSpeeds = median(speeds,1);
    
    colors = getColors();
    
    figure
    maxSpeed = max(speeds(:));
    X = speeds(:,1);
    Y = speeds(:,2);
    for i=1:nSessions
        plot(X(i),Y(i),'o','Color',colors(i,:), 'MarkerSize', 8, 'LineWidth',2);
        hold on;
    end
    plot(meanSpeeds(1), meanSpeeds(2), 'x', 'Color','g', 'MarkerSize', 14, 'LineWidth', 3)
    plot(medianSpeeds(1), medianSpeeds(2), 'x', 'Color','b', 'MarkerSize', 14, 'LineWidth', 3)
    title(sprintf('Speed anisotropy for \\Deltaf/f=%g*10^{-4}',threshold*1E4));
    legendLabels = sessionNames;
    legendLabels{nSessions+1} = 'Mean \pm sem';
    legendLabels{nSessions+2} = sprintf('Median \\pm %d pct',medianErrWidth);
    legend(legendLabels{:},'Location','NorthWest')
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
