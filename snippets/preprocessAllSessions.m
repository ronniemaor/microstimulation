function preprocessAllSessions()
    sessionConfigs = getSessionConfigs();
    for sessionKeyCell = sessionConfigs.keys()
        sessionKey = sessionKeyCell{1};
        preprocessAndSave(sessionKey)
    end
end