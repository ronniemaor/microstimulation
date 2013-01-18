function signal = relativeSignal(conds,range,stimConds,blankConds)
% compute signal from stim/blank
if nargin < 2
    range = 2:230; % HARDCODED
end    
if nargin < 3
    stimConds = 1:3; % HARDCODED
end
if nargin < 4
    blankConds = 4:6; % HARDCODED
end
stim = nanmean(conds(:,range,stimConds),3);
blank = nanmean(conds(:,range,blankConds),3);
signal = stim ./ blank - 1;
