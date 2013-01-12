%% compute signal from stim/blank
range = 2:230; % HARDCODED
stim = nanmean(condsn(:,range,1:3),3);
blank = nanmean(condsn(:,range,4:6),3);
signal = stim ./ blank - 1;

%% find "chamber mask"
blankn = mean(condsn(:,:,4:6),3);
blVes = mean(blankn(:,2:100),2);
outOfChamberValue = blVes(1); % assume top-left corner is outside chamber
mask = blVes ~= outOfChamberValue;