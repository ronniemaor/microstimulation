function [blank,stims] = preprocessSession(dataDir)
    dayPrefix = getPrefixFromDataDir(dataDir);
    nPixels = 10000; nFrames = 256;
    
    nBlanks = 0; 
    nStims = 0;
    blank = zeros(nPixels,nFrames);
    for iCond = 1:6
        isBlank = iCond >= 4;
        fprintf('Condition %d. isBlank=%d\n', iCond, isBlank)
        condFiles = dir(sprintf('%s\\%s_%d*.mat', dataDir, dayPrefix, iCond));
        nFiles = size(condFiles,1);
        for iFile=1:nFiles
            filename = sprintf('%s\\%s', dataDir, condFiles(iFile).name);
            fprintf('\tReading File %s\n', filename)
            fileData = load(filename);
            normalized = normalizeTrial(fileData.FRMpre);
            if isBlank
                nBlanks = nBlanks + 1;
                blank = blank + normalized;
            else
                nStims = nStims + 1;
                stims(:,:,nStims) = normalized;
            end
        end
        fprintf('\n')
    end
    blank = blank / nBlanks;
end

function prefix = getPrefixFromDataDir(dataDir)
    parts = splitstring(dataDir,filesep);
    parts = splitstring(parts{end-1},'_');
    day = parts{end};
    month = parts{end-1};
    prefix = [day,month];
end

function normalized = normalizeTrial(trial)
    zeroFrame = mean(trial(:,20:23),2);
    normalized = trial ./ zeroFrame(:,ones(1,256));
    noiseThreshold = 0.15 * max(trial(:));
    normalized(trial < noiseThreshold) = 1;
end