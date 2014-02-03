function res = cacheTimeCourseParams(sessionKey, parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    fit = take_from_struct(parms,'fit',GaussianFit);
    frameRange = take_from_struct(parms,'frameRange',20:50);
    filename = sprintf('%s/timecourse-%s-%s-%d-to-%d.mat', getCacheDir(), sessionKey, fit.name(), min(frameRange), max(frameRange));
    
    if exist(filename,'file')
        res = load(filename);
        return;
    end
    
    W = 9;
    nBins = 2;
    R2_threshold = 0.6; % don't use points below this threshold
    sigma_threshold = 10; % don't use points above this sigma (Gaussian fit only)
        
    paramNames = fit.paramNames();
    nParams = length(paramNames);

    res = struct;
    res.fitName = fit.name();
    res.frameRange = frameRange;
    res.sessionKey = sessionKey;
    
    data = loadData(sessionKey, parms);
    data = findPeak(data);

    for iSlice = 1:2
        isVertical = iSlice==2;
        sliceStruct = struct;

        [P, err, ~, ~] = fitsOverTime(fit, data.signal, data.mask, frameRange, W, data.C, isVertical, nBins);

        highR2 = err > R2_threshold;
        goodPositions = highR2; % can't trust fits with R2 below this threshold
        for iParam = 1:nParams
            if strcmpi(paramNames{iParam},'sigma')
                smallSigma = P(iParam,:) < sigma_threshold;
                goodPositions = goodPositions & smallSigma;
            end
        end
        sliceStruct.goodFrames = frameRange(goodPositions);
        sliceStruct.P = P(:,goodPositions);
        
        for iParam = 1:nParams
            sliceStruct.(paramNames{iParam}) = P(iParam,goodPositions);
        end

        sliceStruct.R2 = err;

        res.(sliceName(isVertical)) = sliceStruct;            
    end

    save(filename, '-struct', 'res');
end

