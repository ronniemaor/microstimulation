function sigmaRatiosOverTime(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    frameRange = take_from_struct(parms, 'frameRange', 28:45);
    allSessions = getSessionsFromParms(parms);

    colors = getColors();
    
    nSessions = 0;
    sessionNames = {};
    sessionMeanRatios = [];
    myfigure;
    for cSession = allSessions
        sessionKey = cSession{1};
        if isequal(sessionKey,'J29j') 
            continue % no fits for Horizontal, non linear sigma changes for Vertical (maybe we can use only vertical?)
        end;
        nSessions = nSessions + 1;
        sessionNames{nSessions} = sessionKey;
        [t,ratios] = calcRatios(sessionKey,frameRange,parms);
        sessionMeanRatios(nSessions) = mean(ratios);
        plot(t,ratios,'Color',colors(nSessions,:),'LineWidth',2,'Marker','o', 'MarkerSize', 8);
        hold on;
    end
    
    title('Anisotropy of activation spread over time');
    legend(sessionNames{:},'Location','NorthEastOutside')
    xlabel('time [msec]')
    ylabel('\sigma_h/\sigma_v')
    
    meanRatio = mean(sessionMeanRatios);
    ratioSEM = std(sessionMeanRatios) / sqrt(length(sessionMeanRatios));
    fprintf('H/V: mean=%.2g, s.e.m=%.2g\n', meanRatio , ratioSEM)
end

function [t,ratios] = calcRatios(sessionKey,frameRange,parms)
    P = cacheTimeCourseParams(sessionKey,parms);
    sigmaH = P.Horizontal.sigma;
    sigmaV = P.Vertical.sigma;
    
    t = [];
    ratios = [];
    for frame = frameRange
        iH = find(P.Horizontal.goodFrames == frame, 1);
        iV = find(P.Vertical.goodFrames == frame, 1);
        if isempty(iH) || isempty(iV)
            continue; % frames with bad fits are not kept
        end
        valH = sigmaH(iH);
        valV = sigmaV(iV);
        t = [t frame];
        ratios = [ratios valH/valV];
    end
end