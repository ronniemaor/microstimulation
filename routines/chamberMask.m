function mask = chamberMask(conds)
% find "chamber mask" - logical mask of pixels "in the chamber"
blankConds = 4:6; % HARDCODED
baseFrames = 2:100; % HARDCODED
blankn = mean(conds(:,:,blankConds),3);
blVes = mean(blankn(:,baseFrames),2);
outOfChamberValue = blVes(1); % assume top-left corner is outside chamber
mask = blVes ~= outOfChamberValue;