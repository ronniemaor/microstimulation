function preprocessAndSave(sessionKey)
    % read the raw files and do the preprocessing
    fprintf('\n**** Preprocessing session %s\n\n', sessionKey)
    dataDir = getSessionDataDir(sessionKey);
    [blank, stims, rawBlank, mask, allBlanks] = preprocessSession(dataDir);

    % we're only interested in early times, so keep files small
    % by keeping only initial frames for the stimulus
    nFrames = 80;
    frameRange = 1:nFrames;
    stims = stims(:,frameRange,:);
    allBlanks = allBlanks(:,frameRange,:);
    
    % save 
    filename = [dataDir,'/preprocessed'];
    fprintf('***** Saving preprocessed data to %s\n', filename)
    version = preprocessingVersion();
    
    signal = relativeSignal(blank,stims,frameRange);
    
    save(filename, 'version', 'blank', 'stims', 'signal', 'rawBlank', 'mask', 'allBlanks')
end

function signal = relativeSignal(blank,stims,frameRange)
    % Input:
    %   blank - pixels*frames
    %   stims - pixels*frames*trials
    % Output
    %   signal - stimulus/blank - 1 for each matching pixel*frame
    %            signal dimentions are pixels*frames*trials
    if nargin < 3
        frameRange = 2:230; % HARDCODED
    end    
    nTrials = size(stims,3);
    relevantStims = stims(:,frameRange,:);
    relevantBlanks = blank(:, frameRange, ones(1,nTrials));
    signal = relevantStims ./ relevantBlanks - 1;
end