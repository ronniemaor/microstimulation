function baseDataDir = getBaseDataDir()
    baseDataDir = 'C:/data/microstimulation';
    if ~exist(baseDataDir,'dir')
        error('Could not find baseDataDir')
    end
end
