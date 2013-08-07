function dataDir = getSessionDataDir(sessionKey)
    config = getSessionConfig(sessionKey);
    dataDir = [getBaseDataDir(), '/', config.dataDir];
end