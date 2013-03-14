function err = calcRMSerr(yTest,yFit)
% Compute RMS of diffs between test data and given fit
% Input:
%   yFit: (1 x nPoints) row vector of fit values
%   yTest: (nTrials x nPoints) rows of test data values
% Output:
%   res: RMS value
    nTrials = size(yTest,1);
    yFitDuplicated = yFit(ones(1,nTrials),:);
    squareFitDiffs = (yTest - yFitDuplicated) .^ 2;
    err = sqrt(mean(squareFitDiffs(:)));
    
%     bestFit = mean(yTest,1);
%     yFitDuplicated = bestFit(ones(1,nTrials),:);
%     squareFitDiffs = (yTest - yFitDuplicated) .^ 2;
%     bestErr = sqrt(mean(squareFitDiffs(:)));
%     
%     err = err - bestErr;
end
