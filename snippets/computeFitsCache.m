function computeFitsCache(parms, bForce)
    if ~exist('bForce','var')
        bForce = 0;
    end

    allSessions = getSessionsFromParms(parms);
    cacheDir = getCacheDir(parms);
    for cSession = allSessions
        sessionKey = cSession{1};
        fprintf('**** Computing fits for session %s under %s\n', sessionKey, cacheDir)
        cacheTimeCourseParams(sessionKey,add_parms(parms, 'forceRecompute', bForce));
    end
end
