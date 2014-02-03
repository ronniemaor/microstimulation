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
    
    % apply manual mask if configured
    config = getSessionConfig(data.sessionKey);
    fMask = config.manualMaskFunction;
    data.origMask = data.mask;
    if ~isempty(fMask)
        for x = 1:100
            for y = 1:100
                if ~fMask(x,y)
                    ind = sub2ind([100 100],x,y);
                    data.mask(ind)= 0;
                end
            end
        end
    end
    
    % apply blood vessel mask if configured
    b_use_blood_vessel_mask = take_from_struct(parms, 'use_blood_vessel_mask', true);
    if b_use_blood_vessel_mask
        maskFile = [sessionDataDir, '/../exclusionMask.mat'];
        if exist(maskFile,'file')
            fprintf('Loading mask from file %s\n',maskFile)
            maskData = load(maskFile);
            data.mask(maskData.points) = 0;
        end
    else
        fprintf('NOT loading blood vessel mask from file\n')
    end
    
    % remove blood vessels using PCA
    data.orig_signal = data.signal;
    data = cleanBloodVesselsUsingPCA(data,parms);
end

function data = preprocessData(sessionKey, parms, bAfterReload)
    assert(~bAfterReload, 'Already tried preprocessing. Failing.\n')
    preprocessAndSave(sessionKey);
    data = loadData(sessionKey, parms, true);
end
