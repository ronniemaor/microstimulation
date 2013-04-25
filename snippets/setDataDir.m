baseDataDir = 'C:/data/zuta';
if ~exist(baseDataDir,'dir')
    error('Could not find baseDataDir')
end

allSessions = containers.Map();
allSessions('J29c') = 'Leg/leg_2009_01_29/c';
allSessions('J29g') = 'Leg/leg_2009_01_29/g';
allSessions('J29i') = 'Leg/leg_2009_01_29/i';
allSessions('J29j') = 'Leg/leg_2009_01_29/j';
allSessions('M18b') = 'Leg/leg_2009_03_18/b';
allSessions('M18c') = 'Leg/leg_2009_03_18/c';
allSessions('M18d') = 'Leg/leg_2009_03_18/d';
allSessions('M18e') = 'Leg/leg_2009_03_18/e';
allSessions('A1d') = 'Leg/leg_2009_04_01/d';

sessionKey = 'J29c';

sessionDir = allSessions(sessionKey);
dataDir = [baseDataDir, '/', sessionDir];
fprintf('Using session %s. Setting data dir to %s\n', sessionKey, dataDir)