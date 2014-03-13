function saveExclusionMask(sessionKey,maskType,points)
    dataDir = getSessionDataDir(sessionKey);
    commonDir = fileparts(dataDir);
    filename = sprintf('%s/%sMask.mat', commonDir, maskType);
    fprintf('***** Saving %s mask to %s\n', maskType, filename)
    save(filename, 'points')
end
