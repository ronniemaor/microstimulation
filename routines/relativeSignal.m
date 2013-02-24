function signal = relativeSignal(blank,stims,range)
% compute signal from stim/blank
if nargin < 3
    range = 2:230; % HARDCODED
end    
stim = nanmean(stims(:,range,:),3);
signal = stim ./ blank(:,range) - 1;
