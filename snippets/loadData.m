function data = loadData(sessionKey)
    sessionDataDir = getSessionDataDir(sessionKey);
    dataFile = [sessionDataDir, '/preprocessed'];
    fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    data = load(dataFile);
    data.sessionKey = sessionKey;
end
