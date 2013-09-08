function data = loadData(sessionKey, bSilent)
    if nargin < 2
        bSilent = 0;
    end
    sessionDataDir = getSessionDataDir(sessionKey);
    dataFile = [sessionDataDir, '/preprocessed'];
    if ~bSilent
        fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    end
    data = load(dataFile);
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
    maskFile = [sessionDataDir, '/../exclusionMask.mat'];
    if exist(maskFile,'file')
        maskData = load(maskFile);
        data.mask(maskData.points) = 0;
    end
end
