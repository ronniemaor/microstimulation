function baseDataDir = getBaseDataDir()
    baseDataDir = 'C:/data/zuta';
    if ~exist(baseDataDir,'dir')
        error('Could not find baseDataDir')
    end
end
