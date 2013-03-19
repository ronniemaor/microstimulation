baseDataDir = 'C:/data/zuta';
if ~exist(baseDataDir,'dir')
    error('Could not find baseDataDir')
end
sessionDir = 'Leg/leg_2009_01_29/c';
%sessionDir = 'Leg/leg_2009_04_01/d';
dataDir = [baseDataDir, '/', sessionDir];
fprintf('Setting data dir to %s\n', dataDir)