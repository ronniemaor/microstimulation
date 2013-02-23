function [conds,condsn] = preprocessSession(dataDir,dayPrefix)

% conds = mean of all measurements for each condition
conds = zeros(10000,256,6);
for iCond = 1:6
    fprintf('Condition %d\n', iCond)
    condFiles = dir(sprintf('%s\\%s_%d*.mat', dataDir, dayPrefix, iCond));
    oneCond = zeros(10000,256);
    nFiles = size(condFiles,1);
    for iFile=1:nFiles
        filename = sprintf('%s\\%s', dataDir, condFiles(iFile).name);
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
condsn = conds ./ condszero(:,ones(1,256),:);
noiseThreshold = 0.15 * max(conds(:)); % 15% of maximum value
condsn(conds < noiseThreshold) = 1;
