dataDir = 'C:\data\zuta\Leg\leg_2009_01_29\c';

% conds = mean of all measurements for each condition
conds = zeros(10000,256,6);
for iCond = 1:6
    fprintf('Condition %d\n', iCond)
    condFiles = dir(sprintf('%s\\2901_%d*.mat', dataDir, iCond));
    oneCond = zeros(10000,256);
    nFiles = size(condFiles,1);
    for iFile=1:nFiles
        filename = [dataDir, '\', condFiles(iFile).name];
        fprintf('\tReading File %s\n', filename)
        fileData = load(filename);
        oneCond = oneCond + fileData.FRMpre;
    end
    fprintf('\n')
    conds(:,:,iCond) = oneCond / nFiles;
end

% condsnOld = conds normalized by mean of frames 20:23
fprintf('Computing condsnOld\n')
condszero = mean(conds(:,20:23,:),2);
condsnOld = conds ./ condszero(:,ones(1,256),:);

% condsn = condsnOld after removing values below threshold
fprintf('Computing condsn\n')
maxVal = max(conds(:));
valNoise = 0.15 * maxVal;
condsn = condsnOld;
condsn(conds < valNoise) = 1;
