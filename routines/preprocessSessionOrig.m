function [conds,condsn] = preprocessSessionOrig(dataDir)
    dayPrefix = getPrefixFromDataDir(dataDir);
    nPixels = 10000; nFrames = 256;

    % conds = mean of all measurements for each condition
    conds = zeros(nPixels,nFrames,6);
    for iCond = 1:6
        condFiles = dir(sprintf('%s/%s_%d*.mat', dataDir, dayPrefix, iCond));
        nFiles = size(condFiles,1);
        fprintf('Condition %d (%d files)\n', iCond, nFiles)
        oneCond = zeros(nPixels,nFrames);
        for iFile=1:nFiles
            filename = sprintf('%s/%s', dataDir, condFiles(iFile).name);
            fprintf('\tReading File %s\n', filename)
            fileData = load(filename);
            oneCond = oneCond + fileData.FRMpre;
        end
        fprintf('\n')
        conds(:,:,iCond) = oneCond / nFiles;
    end

    % normalize by "zero frame" and 
    % and remove values below 15% of maximum value
    fprintf('Computing condsn\n')
    condszero = mean(conds(:,20:23,:),2);
    condsn = conds ./ condszero(:,ones(1,nFrames),:);
    %noiseThreshold = 0.15 * max(conds(:)); % 15% of maximum value
    noiseThreshold = 0.15 * min(max(max(conds))); % 15% of "maximum" value (small bug in original code)
    condsn(conds < noiseThreshold) = 1;
end

function prefix = getPrefixFromDataDir(dataDir)
    parts = splitstring(dataDir,'/');
    parts = splitstring(parts{end-1},'_');
    day = parts{end};
    month = parts{end-1};
    prefix = [day,month];
end

