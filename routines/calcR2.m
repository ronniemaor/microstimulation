function res = calcR2(yTest,yFit)
% Compute R2 between test data and given fit
% Input:
%   yFit: (1 x nPoints) row vector of fit values
%   yTest: (nTrials x nPoints) rows of test data values
% Output:
%   res: R2 value
    res = avgCorrVersion(yTest,yFit);
end

function res = avgCorrVersion(yTest,yFit)
    res = corr(mean(yTest,1)',yFit') ^ 2;
end

% function res = corrVersion(yTest,yFit)
%     nTrials = size(yTest,1);
%     Rho = zeros(nTrials,1);
%     for iTrial = 1:nTrials
%         Rho(iTrial) = corr(yTest(iTrial,:)',yFit') ^ 2;
%     end
%     res = mean(Rho);
% end

% function res = newPerTrialVersion(yTest,yFit)
%     nTrials = size(yTest,1);
%     trialR2s = zeros(1,nTrials);
%     for iTrial = 1:nTrials
%         yTestRow = yTest(iTrial,:);
%         SStot = sum( (yTestRow - mean(yTestRow)) .^ 2 );
%         SSerr = sum((yTestRow - yFit) .^ 2);
%         trialR2s(iTrial) = 1 - SSerr/SStot;
%     end    
%     res = mean(trialR2s);
% end
% 
% function res = newVersion(yTest,yFit)
%     nTrials = size(yTest,1);
% 
%     squareDiffs = (yTest - mean(yTest(:))) .^ 2;
%     SStot = sum(squareDiffs(:)) ;
%     
%     yFitDuplicated = yFit(ones(1,nTrials),:);
%     squareFitDiffs = (yTest - yFitDuplicated) .^ 2;
%     SSerr = sum(squareFitDiffs(:));
% 
%     res = 1 - SSerr/SStot;        
% end
% 
