function res = cacheTimeCourseParams(fit, frameRange, specificSessions)
    filename = sprintf('%s/timecourse-%s-%d-to-%d.mat', getCacheDir(), fit.name(), min(frameRange), max(frameRange));
    
    if exist(filename,'file')
        res = load(filename);
        return;
    end
    
    if ~exist('specificSessions', 'var')
        allConfigs = getAllSessionConfigs();
        allSessions = allConfigs.keys();
    else
        allSessions = specificSessions;
    end
    
    W = 9;
    nBins = 2;
    R2_threshold = 0.6; % don't use points below this threshold
    sigma_threshold = 10; % don't use points above this sigma (Gaussian fit only)
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);

    res = struct;
    res.args.fitName = fit.name();
    res.args.frameRange = frameRange;
    
    for cSession = allSessions
        sessionKey = cSession{1};
        data = loadData(sessionKey);
        data = findPeak(data);
        
        sessionStruct = struct;
       
        for iSlice = 1:2
            isVertical = iSlice==2;
            sliceStruct = struct;
            
            [P, err, ~, ~] = fitsOverTime(fit, data.blank, data.stims, data.mask, frameRange, W, data.C, isVertical, nBins);

            highR2 = err > R2_threshold;
            goodPositions = highR2; % can't trust fits with R2 below this threshold
            for iParam = 1:nParams
                if strcmpi(paramNames{iParam},'sigma')
                    smallSigma = P(iParam,:) < sigma_threshold;
                    goodPositions = goodPositions & smallSigma;
                end
            end
            
            for iParam = 1:nParams
                paramStruct = struct;
                paramStruct.frames = frameRange(goodPositions);
                paramStruct.vals = P(iParam,goodPositions);                
                sliceStruct.(paramNames{iParam}) = paramStruct;
            end
            
            R2struct = struct;
            R2struct.frames = frameRange;
            R2struct.vals = err;
            sliceStruct.R2 = R2struct;
            
            sessionStruct.(sliceName(isVertical)) = sliceStruct;            
        end
        res.sessions.(sessionKey) = sessionStruct;
    end

    save(filename, '-struct', 'res');
end

