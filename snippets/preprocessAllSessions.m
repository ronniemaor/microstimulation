function preprocessAllSessions()
    sessionConfigs = getAllSessionConfigs();
    for sessionKeyCell = sessionConfigs.keys()
        sessionKey = sessionKeyCell{1};
        preprocessAndSave(sessionKey)
    end
end