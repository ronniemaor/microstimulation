function dataDir = getSessionDataDir(sessionKey)
    baseDataDir = 'C:/data/zuta';
    if ~exist(baseDataDir,'dir')
        error('Could not find baseDataDir')
    end
    
    sessionConfigs = getSessionConfigs();
    configDir = sessionConfigs(sessionKey).dataDir;
    dataDir = [baseDataDir, '/', configDir];
end