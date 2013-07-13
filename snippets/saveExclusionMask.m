function saveExclusionMask(sessionKey,points)
    dataDir = getSessionDataDir(sessionKey);
    commonDir = fileparts(dataDir);
    filename = [commonDir,'/exclusionMask'];
    fprintf('***** Saving exclusion mask to %s\n', filename)
    save(filename, 'points')
end
