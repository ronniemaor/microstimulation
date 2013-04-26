function data = loadData(sessionKey)
    fprintf('Using session %s\n', sessionKey)
    sessionDataDir = getSessionDataDir(sessionKey);
    dataFile = [sessionDataDir, '/preprocessed'];
    fprintf('Loading data from %s\n', dataFile)
    data = load(dataFile);
end
