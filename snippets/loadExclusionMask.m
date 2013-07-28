function points = loadExclusionMask(sessionKey)
    dataDir = getSessionDataDir(sessionKey);
    commonDir = fileparts(dataDir);
    filename = [commonDir,'/exclusionMask.mat'];
    if ~exist(filename,'file')
        fprintf('No exclusion mask exists at %s.\nReturning empty mask\n', filename)
        points = [];
        return
    end
    data = load(filename);
    points = data.points;
end
