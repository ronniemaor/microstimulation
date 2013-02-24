function mask = chamberMask(blank)
% find "chamber mask" - logical mask of pixels "in the chamber"
baseFrames = 2:100; % HARDCODED
blVes = mean(blank(:,baseFrames),2);
outOfChamberValue = blVes(1); % assume top-left corner is outside chamber
mask = blVes ~= outOfChamberValue;