function data = loadData(sessionKey, parms, bAfterReload)
    if ~exist('parms', 'var')
        parms = make_parms();
    end
    if ~exist('bAfterReload', 'var')
        bAfterReload = false;
    end
    
    bSilent = take_from_struct(parms, 'bSilent', 0);
    sessionDataDir = getSessionDataDir(sessionKey);
    dataFile = [sessionDataDir, '/preprocessed.mat'];
    if ~exist(dataFile,'file')
        fprintf('No preprocessed file found. Doing the preprocessing...\n')
        data = preprocessData(sessionKey, parms, bAfterReload);
        return;
    end
    if ~bSilent
        fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    end
    data = load(dataFile);
    expected_version = preprocessingVersion();
    version = take_from_struct(data,'version',0);
    if version ~= expected_version
        fprintf('Data is from an old version. Redoing the preprocessing...\n')
        data = preprocessData(sessionKey, parms, bAfterReload);
        return;        
    end
    data.sessionKey = sessionKey;
    data.config = getSessionConfig(sessionKey);
    
    % apply noise mask
    data.origMask = data.mask; % save chamber boundaries mask as origMask
    if take_from_struct(parms, 'exclude_noisy_regions', true);
        data.mask = applyConfiguredMasks(data.sessionKey, 'noise', data.mask);
    else
        fprintf('NOT loading blood vessel mask from file\n')
    end
    
    % apply non-V1 mask
    data.mask = applyConfiguredMasks(data.sessionKey, 'nonV1', data.mask);
    
    % remove blood vessels using PCA
    data.orig_signal = data.signal;
    data = cleanBloodVesselsUsingPCA(data,parms);
end

function data = preprocessData(sessionKey, parms, bAfterReload)
    assert(~bAfterReload, 'Already tried preprocessing. Failing.\n')
    preprocessAndSave(sessionKey);
    data = loadData(sessionKey, parms, true);
end
