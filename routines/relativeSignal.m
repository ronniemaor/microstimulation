function signal = relativeSignal(blank,stims,frameRange)
% Input:
%   blank - pixels*frames
%   stims - pixels*frames*trials
% Output
%   signal - stimulus/blank - 1 for each matching pixel*frame
%            signal dimentions are pixels*frames*trials
if nargin < 3
    frameRange = 2:230; % HARDCODED
end    
nTrials = size(stims,3);
relevantStims = stims(:,frameRange,:);
relevantBlanks = blank(:, frameRange, ones(1,nTrials));
signal = relevantStims ./ relevantBlanks - 1;
