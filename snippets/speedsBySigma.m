function speedsBySigma(specificSessions)
    fit = GaussianFit;
    frameRange = 28:45;
    if ~exist('specificSessions','var')
        allConfigs = getAllSessionConfigs();
        allSessions = allConfigs.keys();
    else
        allSessions = specificSessions;
    end
    P = cacheTimeCourseParams(fit,frameRange);
    
    nSessions = 0;
    sessionNames = {};
    speeds = [];
    for cSession = allSessions
        sessionKey = cSession{1};
        if isequal(sessionKey,'J29j') 
            continue % no fits for Horizontal, non linear sigma changes for Vertical (maybe we can use only vertical?)
        end;
        nSessions = nSessions + 1;
        sessionNames{nSessions} = sessionKey;
        sH = findSpeed(P,sessionKey,0);
        sV = findSpeed(P,sessionKey,1);
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
    X = speeds(:,1);
    Y = speeds(:,2);
    for i=1:nSessions
        plot(X(i),Y(i),'o','Color',colors(i,:), 'MarkerSize', 8, 'LineWidth',2);
        hold on;
    end
    title('Sigma speed anisotropy');
    legend(sessionNames{:},'Location','NorthWest')
    axis equal
    xlabel('Horizontal speed [cm/s]')
    ylabel('Vertical speed [cm/s]')
    lim = [0 3.2];
    xlim(lim);
    ylim(lim);
    hold on
    plot(lim,lim,'g')    
end

function s = findSpeed(P, sessionKey,isVertical)
    strSlice = sliceName(isVertical);
    sigma = P.sessions.(sessionKey).(strSlice).sigma;

    x = sigma.frames';
    y = sigma.vals';
    if isequal(sessionKey,'M18b') && ~isVertical
        goodFrames = x <= 35;
        x = x(goodFrames);
        y = y(goodFrames);
    end

    n = length(x);
    X = [x ones(n,1)];
    w = X \ y;
    
    s = 10*w(1); % in cm/s (sigma is in mm, frames are 10 msec)

%     y2 = X*w;
%     plot(x,y,'b',x,y2,'r')
%     title(sprintf('%s - %s', sessionKey, strSlice));
%     pause
end