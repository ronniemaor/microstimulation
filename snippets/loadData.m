function data = loadData(sessionKey)
    sessionDataDir = getSessionDataDir(sessionKey);
    dataFile = [sessionDataDir, '/preprocessed'];
    fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    data = load(dataFile);
    data.sessionKey = sessionKey;
    
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
end
