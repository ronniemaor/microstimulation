function sessionActivationsAndSpeeds(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    allSessions = getSessionsFromParms(parms);
    
    bShowRaw = take_from_struct(parms,'bShowRaw',true);
    bShowFits = take_from_struct(parms,'bShowFits',true);
    
    for cSession = allSessions
        sessionKey = cSession{1};
        for isVertical=0:1
            if bShowRaw
                data = loadData(sessionKey, parms);
                activationBoundaryRaw(data,isVertical,parms);
            end
            if bShowFits
                activationBoundaryFits(sessionKey,isVertical,parms);
            end
        end
    end
end
