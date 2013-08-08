function sigmaRatiosOverTime(specificSessions)
    fit = GaussianFit;
    frameRange = 28:45;
    if ~exist('specificSessions','var')
        allConfigs = getAllSessionConfigs();
        allSessions = allConfigs.keys();
    else
        allSessions = specificSessions;
    end
    P = cacheTimeCourseParams(fit,frameRange);

    colors = [ ...
        0,    0,    1; ...
        0,    0.5,  0; ...
        1,    0,    0; ...
        0,    0.75, 0.75; ...
        0.75, 0,    0.75; ...
        0.75, 0.75, 0; ...
        0.25, 0.25, 0.25 ...
    ];
    
    nSessions = 0;
    sessionNames = {};
    sessionMeanRatios = [];
    figure;
    for cSession = allSessions
        sessionKey = cSession{1};
        if isequal(sessionKey,'J29j') 
            continue % no fits for Horizontal, non linear sigma changes for Vertical (maybe we can use only vertical?)
        end;
        nSessions = nSessions + 1;
        sessionNames{nSessions} = sessionKey;
        [t,ratios] = calcRatios(P, sessionKey);
        sessionMeanRatios(nSessions) = mean(ratios);
        plot(t,ratios,'Color',colors(nSessions,:),'LineWidth',2);
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

function [t,ratios] = calcRatios(P, sessionKey)
    sigmaH = P.sessions.(sessionKey).Horizontal.sigma;
    sigmaV = P.sessions.(sessionKey).Vertical.sigma;
    
    t = [];
    ratios = [];
    for iH = 1:length(sigmaH.frames)
        frameH = sigmaH.frames(iH);
        valH = sigmaH.vals(iH);
        iV = find(sigmaV.frames == frameH);
        if iV
            frameV = sigmaV.frames(iV);
            valV = sigmaV.vals(iV);
            assert(frameV == frameH)
            t = [t frameH];
            ratios = [ratios valH/valV];
        end
    end
end