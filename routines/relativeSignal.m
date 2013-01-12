function signal = relativeSignal(conds,range)
% compute signal from stim/blank
if nargin < 2
    range = 2:230; % HARDCODED
end    
stimConds = 1:3; % HARDCODED
blankConds = 4:6; % HARDCODED
stim = nanmean(conds(:,range,stimConds),3);
blank = nanmean(conds(:,range,blankConds),3);
signal = stim ./ blank - 1;
