function sessionActivationsAndSpeeds(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    allSessions = getSessionsFromParms(parms);
    
    for cSession = allSessions
        sessionKey = cSession{1};
        data = loadData(sessionKey);
        for isVertical=0:1
            activationBoundaryRaw(data,isVertical,parms);
            activationBoundaryFits(data.sessionKey,isVertical,parms);
        end
    end
end
