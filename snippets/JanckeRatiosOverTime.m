function JanckeRatiosOverTime(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    allSessions = getSessionsFromParms(parms);
    
    threshold = take_from_struct(parms, 'threshold', 1E-3 * 0.5);

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
        [t,ratios] = calcRatios(sessionKey,threshold);
        sessionMeanRatios(nSessions) = mean(ratios);
        plot(t,ratios,'Color',colors(nSessions,:),'LineWidth',2);
        hold on;
    end
    
    title(sprintf('Anisotropy of activation spread over time for \\Deltaf/f=%g*10^{-4}',threshold*1E4));
    legend(sessionNames{:},'Location','NorthEastOutside')
    xlabel('time [msec]')
    ylabel('\sigma_h/\sigma_v')
    
    meanRatio = mean(sessionMeanRatios);
    ratioSEM = std(sessionMeanRatios) / sqrt(length(sessionMeanRatios));
    fprintf('Threshold=%gE-4. H/V: mean=%.2g, s.e.m=%.2g\n', threshold*1E4, meanRatio , ratioSEM)
end

function [t,ratios] = calcRatios(sessionKey,threshold)
    boundaryParms = make_parms('bPlot',false,'thresholds',threshold);
    [~,framesH,boundariesH] = activationBoundaryFits(sessionKey,0,boundaryParms);
    [~,framesV,boundariesV] = activationBoundaryFits(sessionKey,1,boundaryParms);
    assert(isequal(framesH,framesV))
    
    t = [];
    ratios = [];
    for iFrame = 1:length(framesH)
        frame = framesH(iFrame);
        valH = boundariesH(iFrame);
        valV = boundariesV(iFrame);
        if isnan(valH) || isnan(valV)
            continue;
        end
        t = [t frame];
        ratios = [ratios valH/valV];
    end
end
