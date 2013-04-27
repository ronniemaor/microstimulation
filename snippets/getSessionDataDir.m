function dataDir = getSessionDataDir(sessionKey)
    baseDataDir = 'C:/data/zuta';
    if ~exist(baseDataDir,'dir')
        error('Could not find baseDataDir')
    end
    
    config = getSessionConfig(sessionKey);
    dataDir = [baseDataDir, '/', config.dataDir];
end