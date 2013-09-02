function sessions = getSessionsFromParms(parms)
    allConfigs = getAllSessionConfigs();
    allSessions = allConfigs.keys();
    sessions = take_from_struct(parms,'sessions',allSessions);
end