function [mask, foundMask] = applyConfiguredMasks(sessionKey, maskType, origMask)
    % Look for pixel masks of given type in file and/or config and merge
    % all relevant masks found with origMask.
    % If origMask is not given, then an all-ones mask is assumed (no masking)
    if exist('origMask','var')
        mask = origMask;
    else
        mask = ones(10000,1);
    end

    foundMask = false;
        
    % look for mask function in config
    config = getSessionConfig(sessionKey);
    fieldname = sprintf('%sMaskFunction', maskType);
    if isprop(config, fieldname) % no all mask types have config.xxxMaskFunction option (only the ones we actually needed)
        fMask = config.(fieldname);
        if ~isempty(fMask)
            foundMask = true;
            for x = 1:100
                for y = 1:100
                    if fMask(x,y)
                        ind = sub2ind([100 100],x,y);
                        mask(ind)= 0;
                    end
                end
            end
        end
    end
    
    % look for mask file
    maskFile = sprintf('%s/../%sMask.mat', getSessionDataDir(sessionKey), maskType);
    if exist(maskFile,'file')
        fprintf('Loading mask from file %s\n',maskFile)
        foundMask = true;
        maskData = load(maskFile);
        mask(maskData.points) = 0;
    end
end
