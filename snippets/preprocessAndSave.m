function preprocessAndSave(sessionKey)
    % read the raw files and do the preprocessing
    fprintf('\n**** Preprocessing session %s\n\n', sessionKey)
    dataDir = getSessionDataDir(sessionKey);
    [blank, stims, rawBlank, mask, allBlanks] = preprocessSession(dataDir);

    % we're only interested in early times, so keep files small
    % by keeping only initial frames for the stimulus
    nFrames = 80;     
    stims = stims(:,1:nFrames,:);
    allBlanks = allBlanks(:,1:nFrames,:);
    
    % save 
    filename = [dataDir,'/preprocessed'];
    fprintf('***** Saving preprocessed data to %s\n', filename)
    version = preprocessingVersion();
    save(filename, 'version', 'blank', 'stims', 'rawBlank', 'mask', 'allBlanks')
end