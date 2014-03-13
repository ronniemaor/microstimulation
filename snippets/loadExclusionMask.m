function points = loadExclusionMask(sessionKey, maskType)
    dataDir = getSessionDataDir(sessionKey);
    commonDir = fileparts(dataDir);
    filename = sprintf('%s/%sMask.mat', commonDir, maskType);
    if ~exist(filename,'file')
        fprintf('No mask file exists at %s.\nReturning empty mask\n', filename)
        points = [];
        return
    end
    data = load(filename);
    points = data.points;
end
