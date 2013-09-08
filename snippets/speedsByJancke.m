function speedsByJancke(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    allSessions = getSessionsFromParms(parms);
    
    threshold = take_from_struct(parms, 'threshold', 1E-3 * 0.5);
    
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
        sH = findSpeed(sessionKey,0,threshold);
        sV = findSpeed(sessionKey,1,threshold);
        speeds(nSessions,:) = [sH sV];
    end

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
    maxSpeed = max(speeds(:));
    X = speeds(:,1);
    Y = speeds(:,2);
    for i=1:nSessions
        plot(X(i),Y(i),'o','Color',colors(i,:), 'MarkerSize', 8, 'LineWidth',2);
        hold on;
    end
    title(sprintf('Speed anisotropy for \\Deltaf/f=%g*10^{-4}',threshold*1E4));
    legend(sessionNames{:},'Location','NorthWest')
    axis equal
    xlabel('Horizontal speed [cm/s]')
    ylabel('Vertical speed [cm/s]')
    lim = [0 1.1*maxSpeed];
    xlim(lim);
    ylim(lim);
    hold on
    plot(lim,lim,'g')    
end

function s = findSpeed(sessionKey,isVertical,threshold)
    s = activationBoundaryFits(sessionKey,isVertical, make_parms('thresholds',threshold,'bPlot',false));
end
